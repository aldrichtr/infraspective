
<#
.SYNOPSIS
    BuildTool Configuration file
.DESCRIPTION
    Each parameter uses the 'property' alias of Invoke-Build, which looks in:
    - Session
    - Environment
    - Default
    to determine the value.  So, each variable can be set (either as a parameter,
    script variable, or Environment variable) prior to this script
    being run, and that value will be used instead of the one set here.
#>
param(
    # BuildRoot is automatically set by Invoke-Build, but it could
    # be modified here so that hierarchical builds can be done
    [Parameter()]
    [string]
    $BuildRoot = (property BuildRoot $BuildRoot),

    # BuildTools is ./build by default (if you followed the README)
    [Parameter()]
    [string]
    $BuildTools = (property BuildTools "$BuildRoot\build"),

    # BuildTools header output
    [Parameter()]
    [ValidateSet('minimal', 'normal', 'verbose')]
    [string]
    $Header = (property Header 'verbose'),

    # Custom configuration settings file
    [Parameter()]
    [string]
    $ConfigFile = (property ConfigFile ""),

    # an array of paths to additional task files
    [Parameter()]
    [string[]]
    $TaskFiles = (property TaskFiles @("$BuildTools\tasks")),

    # This is the module name used in many directory, file and script
    # functions
    [Parameter()]
    [string]
    $ModuleName = (property ModuleName (Get-Item -Path $BuildRoot).BaseName),

    # Build Type
    [Parameter()]
    [ValidateSet("Testing", "Debug", "Release")]
    [string]
    $Type = (property Type "Testing"),

    # Name of the module file (<modulename>.psm1 by default)
    # this name is added to path parameters such as Source.Path, etc.
    # Relies on $ModuleName being set prior to invocation.
    [Parameter()]
    [string]
    $ModuleFile = (property ModuleFile "$ModuleName.psm1"),

    # Name of the module manifest file (<modulename>.psd1 by default)
    # this name is added to path parameters such as Source.Path, etc.
    # Relies on $ModuleName being set prior to invocation.
    [Parameter()]
    [string]
    $ModuleManifestFile = (property ModuleManifestFile "$ModuleName.psd1"),

    # A hash of values related to the source files.
    # - Path : by default looks in './<modulename>'
    # - Module : the path to the Source psm1
    # - Manifest : the path to the Source psd1
    # - Types :  an array of source types which assumes the convention of
    #           one function or type per file, organized in directories.
    #           'enum', 'classes', 'private', 'public' by default
    # - CustomLoadOrder : path to a file containing the source file paths in the
    #                     order to be loaded (one file path per line)
    [Parameter()]
    [Hashtable]
    $Source = (property Source @{
            Path            = "$BuildRoot\source\$ModuleName"
            Module          = ""
            Manifest        = ""
            Types           = @('enum', 'classes', 'private', 'public')
            CustomLoadOrder = "$BuildRoot\source\$ModuleName\LoadOrder.txt"
        }),

    # A hash of values related to the documentation
    # - Path : ./docs by default
    [Parameter()]
    [hashtable]
    $Docs = (property Docs @{
            Path = "$BuildRoot\docs"
        }),

    # A hash of values related to the additional tools and scripts
    # - Path : ./tools by default
    [Parameter()]
    [hashtable]
    $Tools = (property Tools @{
            Path = "$BuildRoot\tools"
        }),

    # A hash of values related to the test harness
    # - Path : ./tests by default
    # - Config : A hash of paths to the pester configuration files (.psd1)
    #   - Unit : the basic unit tests to validate code.
    #   - Analyzer : the tests that analyze code according to the
    #                PSScriptAnalyzer rules
    #   - Performance : the tests that analyze performance metrics of the code
    #   - Coverage : generate a code coverage report
    [Parameter()]
    [hashtable]
    $Tests = (property Tests @{
            Path   = "$BuildRoot\tests"
            Config = @{
                Unit        = "$BuildTools\config\pester.config.unittests.psd1"
                Analyzer    = "$BuildTools\config\pester.config.analyzertests.psd1"
                Performance = "$BuildTools\config\pester.config.performancetests.psd1"
                Coverage    = "$BuildTools\config\pester.config.codecoverage.psd1"
            }
        }),

    # A hash of values related to staging. (merging source files, updating the
    # manifest, additional testing, etc.)
    # - Path : by default looks in './stage'
    # - Module : the path to the staged psm1
    # - Manifest : the path to the staged psd1
    [Parameter()]
    [hashtable]
    $Staging = (property Staging @{
            Path     = "$BuildRoot\stage\$ModuleName"
            Module   = ""
            Manifest = ""
        }),

    # A hash of values related to the artifact directory.
    # the nuget package, additional documentation, test results, etc.
    # - Path : ./artifact by default
    [Parameter()]
    [hashtable]
    $Artifact = (property Artifact @{
            Path = "$BuildRoot\out"
        })
)
## fixup some self referencing hash keys
if ($Source.Module -eq '') {$Source.Module = "$($Source.Path)\$ModuleFile"}
if ($Source.Manifest -eq '') {$Source.Manifest = "$($Source.Path)\$ModuleManifestFile"}
if ($Staging.Module -eq '') {$Staging.Module = "$($Staging.Path)\$ModuleFile"}
if ($Staging.Manifest -eq '') {$Staging.Manifest = "$($Staging.Path)\$ModuleManifestFile"}
