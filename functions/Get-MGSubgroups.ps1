<#
.SYNOPSIS
Recursively retrieves subgroups with user members of a specified group in AzureAD/EntraID.

.DESCRIPTION
This function recursively retrieves subgroups that have user members within a specified group in AzureAD/EntraID. It traverses the group hierarchy and returns a list of subgroups that contain user members.

.PARAMETER GroupId
The ID of the group for which subgroups with user members will be retrieved.

.EXAMPLE
Get-MGSubgroups -GroupId "YourGroupId"
Retrieves a list of subgroups with user members within the specified group.

.NOTES
Author: Ole Rand-Hendriksen
GitHub Repository: https://github.com/randriksen/MGNestedGroups
License: GNU General Public License v3.0 (GPL-3.0) - https://www.gnu.org/licenses/gpl-3.0.en.html
#>
function Get-MGSubgroups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$GroupId  # The ID of the group to check
    )

    $group = Get-MgGroup -GroupId $GroupId  # Get the group details
    $groups = @()  # Initialize an empty array to store groups with user members

    if ($group) {
        $subs = Get-MgGroupMember -GroupId $group.Id -All  # Get all members of the group, including users and other groups
    
        foreach ($sub in $subs) {
            if ($sub.AdditionalProperties["@odata.type"] -eq "#microsoft.graph.user") {
                # If $sub is a user, add the current group to the list of groups with user members
                $groups += $group
            }
            elseif ($sub.AdditionalProperties["@odata.type"] -eq "#microsoft.graph.group") {
                # If $sub is a group, recursively get subgroups with user members
            
                $subGroupDetails = Get-MgGroup -GroupId $sub.Id -ErrorAction SilentlyContinue  # Get the details of the subgroup

                if ($subGroupDetails) {
                    $groups += Get-MGSubgroups -GroupId $sub.Id  # Recursively call the function to get subgroups with user members
                }
            }
        }
    }

    # Select and return unique group display names and IDs
    $groups = $groups | Select-Object DisplayName, Id | Get-Unique -AsString
    return $groups
}