# Module script (.psm1) for MGNestedGroupss

# Import all the functions from the Functions folder
$functions = Get-ChildItem -Path "$PSScriptRoot\functions" -Filter *.ps1
foreach ($function in $functions) {
    . $function.fullname
    Export-ModuleMember -Function $function.basename
}
