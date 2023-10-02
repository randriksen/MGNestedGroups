<#
.SYNOPSIS
Revokes a license from leaf groups in a hierarchy of Azure AD groups.

.DESCRIPTION
This function revokes a specified license from all leaf groups within a hierarchy of Azure AD groups. It starts from the top-level group and recursively traverses down the hierarchy, revoking the license from each leaf group.

.PARAMETER TopGroupName
The name of the top-level group from which the hierarchy will be traversed.

.PARAMETER LicenseName
The SKU part number or license name to be revoked from the leaf groups.

.EXAMPLE
Revoke-LicenseFromMGSubgroups -TopGroupName "TopGroup" -LicenseName "YourLicenseName"
Revokes the specified license from all leaf groups within the hierarchy under the "TopGroup" in Azure AD.

.NOTES
Author: Ole Rand-Hendriksen
GitHub Repository: https://github.com/randriksen/MGNestedGroups
License: GNU General Public License v3.0 (GPL-3.0) - https://www.gnu.org/licenses/gpl-3.0.en.html
#>
function Revoke-LicenseFromMGSubgroups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$TopGroupName, # Name of the top-level group
        [Parameter(Mandatory = $true)]
        [string]$LicenseName # SkuPartNumber / license name
    )

    # Get the top-level Azure AD group
    $topGroup = Get-MgGroup -Filter "displayName eq '$TopGroupName'"

    if ($topGroup) {
        # Recursively retrieve subgroups (replace with your function name)
        $subgroups = Get-MGSubgroups -GroupId $topGroup.Id

        # Get the specified license
        $sku = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq $LicenseName

        foreach ($subgroup in $subgroups) {
            Write-Host "Revoking license from $($subgroup.DisplayName)"
            # Revoke the license from the subgroup using Microsoft Graph API
            Set-MgGroupLicense -GroupId $subgroup.Id -AddLicenses @() -RemoveLicenses $sku.SkuId
        }
    }
    else {
        Write-Host "Top-level group '$TopGroupName' not found."
    }
}
