@{
    ModuleVersion = '1.0'
    Author = 'Ole Rand-Hendriksen'
    Description = 'A module for working with nested groups in AzureAD/EntraID. Apply licenses to all subgroups with user members of a specified group. Get all subgroups with user members of a specified group. Add all subgroups with user members as users of an enterprise application.'
    PowerShellVersion = '5.1'  # Minimum required PowerShell version
    Guid = '8f5ca15e-b8bb-4638-9bb6-072a6492e9ba'
    FormatsToProcess = @()
    TypesToProcess = @()
    NestedModules = 'MGNestedGroups.psm1'
    FunctionsToExport =  @('Add-MGSubgroupsToEnterpriseApp', 'Get-MGSubgroups', 'Grant-LicenseToMGSubgroups','Revoke-LicenseFromMGSubgroups','Remove-MGSubgroupsFromEnterpriseApp')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    FileList = @()
    PrivateData = @{
        PSData = @{
            Tags = @()
            ProjectUri = 'https://github.com/randriksen/MGNestedGroups'
            LicenseUri = 'https://www.gnu.org/licenses/gpl-3.0.en.html'
        }
    }
    RequiredModules = @(
        @{
            ModuleName = 'Microsoft.Graph.Users'
            ModuleVersion = '2.6.1'  # Replace with the minimum required version of Microsoft.Graph
        },
        @{
            ModuleName = 'Microsoft.Graph.Groups'
            ModuleVersion = '2.6.1'  # Replace with the minimum required version of Microsoft.Graph
        },
        @{
            ModuleName = 'Microsoft.Graph.Applications'
            ModuleVersion = '2.6.1'  # Replace with the minimum required version of Microsoft.Graph
        }
    )

    
}
