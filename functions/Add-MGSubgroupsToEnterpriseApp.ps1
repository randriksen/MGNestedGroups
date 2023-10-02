<#
.SYNOPSIS
Adds subgroups of a specified top-level group as users of an enterprise application in AzureAD/EntraID.

.DESCRIPTION
This function adds subgroups of a specified top-level group as users to an enterprise application. It associates the specified enterprise application with user subgroups found under the specified top-level group.

.PARAMETER EnterpriseAppId
The Application ID of the enterprise application to which subgroups will be added.

.PARAMETER EnterpriseAppName
The display name of the enterprise application to which subgroups will be added.

.PARAMETER TopGroupName
The name of the top-level group that contains subgroups to be added to the enterprise application.

.PARAMETER TopGroupID
The ID of the top-level group that contains subgroups to be added to the enterprise application.

.EXAMPLE
Add-MGSubgroupsToEnterpriseApp -EnterpriseAppId "YourAppId" -TopGroupName "TopGroup"
Adds all subgroups under the "TopGroup" to the specified enterprise application.

.EXAMPLE
Add-MGSubgroupsToEnterpriseApp -EnterpriseAppName "YourApp" -TopGroupName "TopGroup"
Adds all subgroups under the "TopGroup" to the specified enterprise application by specifying the application name instead of ID.

.NOTES
Author: Ole Rand-Hendriksen
GitHub Repository: https://github.com/randriksen/MGNestedGroups
License: GNU General Public License v3.0 (GPL-3.0) - https://www.gnu.org/licenses/gpl-3.0.en.html
#>
function Add-MGSubgroupsToEnterpriseApp {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EnterpriseAppId, # ID of the enterprise application
        [Parameter()]
        [string] $EnterpriseAppName, # Name of the enterprise application
        [Parameter()]
        [string] $TopGroupName, # Name of the top-level group
        [Parameter()]
        [string] $TopGroupID # ID of the top-level group
    )

    process {
        try {
            if ($EnterpriseAppId -eq $null -and $EnterpriseAppName -eq $null) {
                Write-Host "Please specify either the EnterpriseAppId or EnterpriseAppName parameter."
                return
            }
            if ($EnterpriseAppId -eq ""){
                $app = Get-MgApplication -Filter "displayName eq '$EnterpriseAppName'"
            }
            if ($TopGroupID -eq $null -and $TopGroupName -eq $null) {
                Write-Host "Please specify either the TopGroupID or TopGroupName parameter."
                return
            }
            if ($TopGroupID -eq "") {
                $TopGroupID = (Get-MgGroup -Filter "displayName eq '$TopGroupName'").Id
            }

            if ($null -eq $app) {
                $app = Get-MgApplication -ApplicationId $EnterpriseAppId
            }
            if ($null -eq $app) {
                Write-Host "Enterprise application '$EnterpriseAppId' not found."
                return
            }

            $appid = $app.AppId
            $serviceprincipal = Get-MgServicePrincipal -Filter "appId eq '$appid'"
            $approle = $serviceprincipal.approles | Where-Object DisplayName -eq "User"

            $params = @{
                principalId = ""
                resourceId  = $serviceprincipal.id
                appRoleId   = $approle.Id
            }

            Write-Host "TopGroupID: $TopGroupID"

            # Get the subgroup using the Get-Subgroups function (replace with your function name)
            $subgroups = Get-MGSubgroups -GroupId $TopGroupID

            if ($subgroups.Count -eq 0) {
                Write-Host "Subgroups not found or do not have subgroups."
                continue
            }

            # Add each subgroup as an owner or member to the enterprise application
            foreach ($subgroup in $subgroups) {
                $params.principalId = $subgroup.Id
                Write-Host $subgroup
                New-MgGroupAppRoleAssignment -BodyParameter $params -GroupId $subgroup.Id
                Write-Host "Added subgroup '$subgroup.DisplayName' to the enterprise application '$EnterpriseAppId'."
            }
        }
        catch {
            Write-Host "An error occurred: $_"
        }
    }
}
