<#
.SYNOPSIS
Applies a license to leaf groups in a hierarchy of Azure AD groups.

.DESCRIPTION
This function applies a specified license to all leaf groups within a hierarchy of Azure AD groups. It starts from the top-level group and recursively traverses down the hierarchy, applying the license to each leaf group.

.PARAMETER TopGroupName
The name of the top-level group from which the hierarchy will be traversed.

.PARAMETER LicenseName
The SKU part number or license name to be applied to the leaf groups.

.EXAMPLE
Grant-LicenseToMGSubgroups -TopGroupName "TopGroup" -LicenseName "YourLicenseName"
Applies the specified license to all leaf groups within the hierarchy under the "TopGroup" in Azure AD.

.NOTES
Author: Ole Rand-Hendriksen
GitHub Repository: https://github.com/randriksen/MGNestedGroups
License: GNU General Public License v3.0 (GPL-3.0) - https://www.gnu.org/licenses/gpl-3.0.en.html
#>
function Grant-LicenseToMGSubgroups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$TopGroupName, # Name of the top-level group
        [Parameter(Mandatory = $true)]
        [string]$LicenseName # SkuPartNumber / license name
    )

    # Get the top-level Azure AD group
    $topGroup = Get-MgGroup -Filter "displayName eq '$TopGroupName'"

    $Sku = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq $LicenseName

    if ($topGroup) {
        # Recursively retrieve subgroups (replace with your function name)
        $subgroups = Get-MGSubgroups -GroupId $topGroup.Id

        foreach ($subgroup in $subgroups) {
            Write-Host "Applying license to $($subgroup.DisplayName)"
            # Apply the license to the subgroup using Microsoft Graph API
            Set-MgGroupLicense -GroupId $subgroup.Id -AddLicenses @{SkuId = $Sku.SkuId} -RemoveLicenses @()
        }
    }
    else {
        Write-Host "Top-level group '$TopGroupName' not found."
    }
}
