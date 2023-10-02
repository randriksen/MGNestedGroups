<#
.SYNOPSIS
Removes subgroups from an enterprise application in AzureAD/EntraID.

.DESCRIPTION
This function removes subgroups from an enterprise application. It starts from the top-level group and removes all subgroups from the specified enterprise application. The subgroups are identified by their membership in the top-level group.

.PARAMETER EnterpriseAppId
The Application ID of the enterprise application from which subgroups will be removed.

.PARAMETER EnterpriseAppName
The display name of the enterprise application from which subgroups will be removed.

.PARAMETER TopGroupName
The name of the top-level group whose subgroups will be removed from the enterprise application.

.PARAMETER TopGroupID
The ID of the top-level group whose subgroups will be removed from the enterprise application.

.EXAMPLE
Remove-MGSubgroupsFromEnterpriseApp -EnterpriseAppId "YourAppId" -TopGroupName "TopGroup"
Removes all subgroups under the "TopGroup" from the specified enterprise application.

.NOTES
Author: Ole Rand-Hendriksen
GitHub Repository: https://github.com/randriksen/MGNestedGroups
License: GNU General Public License v3.0 (GPL-3.0) - https://www.gnu.org/licenses/gpl-3.0.en.html
#>
function Remove-MGSubgroupsFromEnterpriseApp {
    [CmdletBinding(SupportsShouldProcess)]
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
            if ($EnterpriseAppId -eq "") {
                $EnterpriseAppId = (Get-MgApplication -ConsistencyLevel eventual -Count appCount -Search "DisplayName:$EnterpriseAppName").Id
            }
            if ($TopGroupID -eq $null -and $TopGroupName -eq $null) {
                Write-Host "Please specify either the TopGroupID or TopGroupName parameter."
                return
            }
            if ($TopGroupID -eq "") {
                $TopGroupID = (Get-MgGroup -Filter "displayName eq '$TopGroupName'").Id
            }
            
            # Get the enterprise application
            $app = Get-mgapplication -ApplicationId $EnterpriseAppId

            if ($null -eq $app) {
                Write-Host "Enterprise application '$EnterpriseAppId' not found."
                return
            }

            $appid = $app.AppId
            $serviceprincipal = Get-MgServicePrincipal -Filter "appId eq '$appid'"
            $approle = $serviceprincipal.approles | where-object DisplayName -eq "User"

            # Get the subgroup using the Get-Subgroups function (replace with your function name)
            $subgroups = Get-MGSubgroups -GroupId $TopGroupID

            if ($subgroups.Count -eq 0) {
                Write-Host "Subgroups not found or do not have subgroups."
                return
            }

            foreach ($s in $subgroups) {
                $approleid = $approle.id
                $approleassignmentid = Get-MgGroupAppRoleAssignment -GroupId $s.Id | Where-Object AppRoleId -eq $approleid
                foreach ($a in $approleassignmentid) {
                    Remove-MgGroupAppRoleAssignment -AppRoleAssignmentId $a.Id -GroupId $s.Id -WhatIf:$WhatIfPreference
                }

                Write-Host "Removed subgroup '$s.DisplayName' from the enterprise application '$EnterpriseAppId'."
            }
        }
        catch {
            Write-Host "An error occurred: $_"
        }
    }
}

# Example usage:
# Remove-MGSubgroupsFromEnterpriseApp -EnterpriseAppId "YourAppId" -TopGroupName "TopGroup"
