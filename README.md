# MGNestedGroups PowerShell Module

**MGNestedGroups** is a PowerShell module that provides functions for working with nested groups in Azure Active Directory (Azure AD) and EntraID. This module allows you to apply licenses to all subgroups with user members of a specified group, get all subgroups with user members of a specified group, add all subgroups with user members as users of an enterprise application, and more.

## Installation

You can install this module directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/MGNestedGroups/1.0.0) using the following command:

```powershell
Install-Module -Name MGNestedGroups -Scope CurrentUser
```

## Usage
Here are some examples of how to use the functions provided by this module:

```powershell
# Apply a license to subgroups under a specified top-level group
Grant-LicenseToMGSubgroups -TopGroupName "TopGroup" -LicenseName "YourLicenseName"

# Revoke a license from subgroups under a specified top-level group
Revoke-LicenseFromMGSubgroups -TopGroupName "TopGroup" -LicenseName "YourLicenseName"

# Add subgroups as users to an enterprise application
Add-MGSubgroupsToEnterpriseApp -EnterpriseAppId "YourAppId" -TopGroupName "TopGroup"

# Remove subgroups from an enterprise application
Remove-MGSubgroupsFromEnterpriseApp -EnterpriseAppId "YourAppId" -TopGroupName "TopGroup"
```



## Contributing
Contributions are welcome! If you would like to contribute to this project

## License
This module is licensed under the GNU General Public License v3.0 (GPL-3.0). Feel free to use, modify, and distribute it in accordance with the license.

## Author
This module is maintained by Ole Rand-Hendriksen.



If you encounter any issues or have questions, please create an issue on the repository.