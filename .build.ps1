[CmdletBinding()]
param(
    # BuildRoot is automatically set by Invoke-Build, but it could
    # be modified here so that hierarchical builds can be done
    [Parameter()]
    [string]
    $BuildRoot = $BuildRoot,

    # This is the module name used in many directory, file and script
    # functions
    [Parameter()]
    [string]
    $ModuleName = 'infraspective',

    [Parameter()]
    [string]
    $BuildTools = "$BuildRoot\build",

    [Parameter()]
    [Hashtable]
    $Source = @{
            Path            = "$BuildRoot\source\$ModuleName"
            Module          = "$BuildRoot\source\$ModuleName\$ModuleName.psm1"
            Manifest        = "$BuildRoot\source\$ModuleName\$ModuleName.psd1"
            Types           = @('enum', 'classes', 'private', 'public')
            CustomLoadOrder = '$BuildRoot\$ModuleName\LoadOrder.txt'
        }
)

. "$BuildTools\BuildTool.ps1"

task Test {
    Import-Module $Source.Manifest -Force
}, run_unit_tests
