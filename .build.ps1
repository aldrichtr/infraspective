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
    $ModuleName = 'BuildTool',

    [Parameter()]
    [string]
    $BuildTools = "$BuildRoot\BuildTool"
)

. "$BuildTools\BuildTool.ps1"

# define your tasks here

