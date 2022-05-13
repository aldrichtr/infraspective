param (
    # BuildRoot is automatically set by Invoke-Build, but it could
    # be modified here so that hierarchical builds can be done
    [Parameter()]
    [string]$BuildRoot = $BuildRoot,

    [Parameter()]
    [string]$BuildTools = "$BuildRoot\build",

    # This is the module name used in many directory, file and script
    # functions
    [Parameter()]
    [string]
    $ModuleName = 'infraspective',

    # Tags to filter the Pester Tests
    [Parameter(
    )]
    [string]$TestTags
)


. ./build/BuildTool.ps1

$config = Get-BuildConfiguration

$env:PSModulePath += "$($config.Artifact.Path)"


task UnitTest {
    $config = Get-BuildConfiguration
    $pester_config_file = $config.Tests.Config.Unit

    if (-not(Test-Path $pester_config_file)) {
        Write-Build Red "Could not find Unit Test configuration at Tests.Config.Unit -> $pester_config_file"
    } else {
        $PesterConfig = New-PesterConfiguration -Hashtable (Import-Psd $pester_config_file)
        $PesterConfig.TestResult.OutputPath = ".\out\unit_test_results.nunit($(Get-Date -Format 'yyyy-MM-dd-HHmm')).xml"

        $mod = Join-Path -Path $config.Project.Path -ChildPath $config.Project.Modules.Root.Module
        Import-Module $mod -Force
        $PesterResult = Invoke-Pester -Configuration $PesterConfig # passthru must be set to $true
        Export-Clixml -InputObject $PesterResult -Path "./out/pester_invocation_results-unit($(Get-Date -Format 'yyyy-MM-dd-HHmm')).xml"
    }
}

task AnalysisTest {
    $config = Get-BuildConfiguration
    $pester_config_file = $config.Tests.Config.Analyzer

    if (-not(Test-Path $pester_config_file)) {
        Write-Build Red "Could not find Analyzer Test configuration at Tests.Config.Analyzer -> $pester_config_file"
    } else {
        $PesterConfig = New-PesterConfiguration -Hashtable (Import-Psd $pester_config_file)
        $PesterConfig.TestResult.OutputPath = ".\out\analyzer_test_results.nunit($(Get-Date -Format 'yyyy-MM-dd-HHmm')).xml"

        $mod = Join-Path -Path $config.Project.Path -ChildPath $config.Project.Modules.Root.Module
        Import-Module $mod -Force
        $PesterResult = Invoke-Pester -Configuration $PesterConfig # passthru must be set to $true
        Export-Clixml -InputObject $PesterResult -Path "./out/pester_invocation_results-analyzer($(Get-Date -Format 'yyyy-MM-dd-HHmm')).xml"
    }
}

task Test {
    $config = Get-BuildConfiguration
    $mod = Join-Path -Path $config.Project.Path -ChildPath $config.Project.Modules.Root.Module
    Import-Module $mod -Force

    $pConfig = New-PesterConfiguration
    $pConfig.Run.Path = "$BuildRoot\tests"
    $pConfig.Run.SkipRemainingOnFailure = 'None'
    $pConfig.Output.Verbosity = 'Detailed'
    Write-Build DarkBlue "tags given as input: $TestTags"
    if ($null -ne $TestTags) {
        $tags = $TestTags -split ' '
        Write-Build DarkBlue "tags passed to pester : $($tags -join ';')"
        $pConfig.Filter.Tag = $tags
    }
    Invoke-Pester -Configuration $pConfig
}

task Configure {

    $configFile = Get-BuildConfigurationFile
    $pLocation = Get-ProjectRoot
    $xPath = 'Data/Table/Item[@Key="Project"]'
    $x = Import-PsdXml $configFile

    Write-Build Blue "Set Project Path to '$pLocation' in $configFile"

    $project = Get-Psd $x $xPath
    $project.Path = $pLocation
    Set-Psd -Xml $x -XPath $xPath -Value $project

    Export-PsdXml -Path $configFile -Xml $x

    Write-Build Blue "Checking paths and locations"
    $config = Get-BuildConfiguration

    $projectPaths = @(
        $config.Staging.Path,
        "$($config.Staging.Path)/$($config.Project.Name)",
        $config.Artifact.Path,
        $config.Docs.Path
    )

    foreach ($p in $projectPaths) {
    if (-not(Test-Path $p)) {
        Write-Build DarkBlue "Creating $p directory"
        New-Item -Path $p -ItemType Directory
    } else {
        Write-Build Green "$p already exists"
    }

    }
}

task CodeCoverage {
    $config = Get-BuildConfiguration
    $pester_config_file = $config.Tests.Config.Coverage

    if (-not(Test-Path $pester_config_file)) {
        Write-Build Red "Could not find Code Coverage configuration at Tests.Config.Coverage -> $pester_config_file"
    } else {
        $PesterConfig = New-PesterConfiguration -Hashtable (Import-Psd $pester_config_file)

        $mod = Join-Path -Path $config.Project.Path -ChildPath $config.Project.Modules.Root.Module
        Import-Module $mod -Force
        $PesterResult = Invoke-Pester -Configuration $PesterConfig # passthru must be set to $true
        Export-Clixml -InputObject $PesterResult -Path 'out/pester_invocation_results-codecoverage.xml'
    }
}

task Review {
    $pConfig = New-PesterConfiguration
    $pConfig.Run.Path = "$BuildRoot\tests"
    $pConfig.Run.SkipRemainingOnFailure = 'None'
    $pConfig.Filter.Tag = @('analyze')
    $pConfig.Output.Verbosity = 'Detailed'

    $pConfig.TestResult.Enabled = $true
    $pConfig.TestResult.OutputFormat = 'NUnitXml'
    $pConfig.TestResult.OutputPath = "$($Artifact.Path)\testResults.xml"
    $pConfig.Output.CIFormat = 'GitHubActions'

    Invoke-Pester -Configuration $pConfig

}

task Stage Clean, make_staging_module, make_staging_manifest
