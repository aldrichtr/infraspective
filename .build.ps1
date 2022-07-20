param(
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


$leader = ' '
$CurrentIndent = ''

Set-BuildHeader {
    param($Path)
    $level = ($Path -split '/').Count - 1
    $synopsis = Get-BuildSynopsis $Task
    Write-Build White ('- [{0}] {1}' -f $Path, $synopsis)
    $script:CurrentIndent = $leader * $level
}
Set-BuildFooter {
    param($Path)
    Write-Build White ('- Done: {0} in {1} Seconds' -f $Task.Name, $Task.Elapsed.Seconds)
}

task UnitTest {
    $config = Get-BuildConfiguration
    $pester_config_file = $config.Tests.Config.Unit

    if (-not(Test-Path $pester_config_file)) {
        Write-Build Red "$CurrentIndent Could not find Unit Test configuration at Tests.Config.Unit -> $pester_config_file"
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
        Write-Build Red "$CurrentIndent Could not find Analyzer Test configuration at Tests.Config.Analyzer -> $pester_config_file"
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
    $pConfig.Run.Exit = $true
    $pConfig.Run.SkipRemainingOnFailure = 'None'
    $pConfig.Output.Verbosity = 'Detailed'
    if ($null -ne $TestTags) {
        Write-Build DarkBlue "$CurrentIndent tags given as input: $TestTags"
        $tags = $TestTags -split ' '
        Write-Build DarkBlue "$CurrentIndent tags passed to pester : $($tags -join ';')"
        $pConfig.Filter.Tag = $tags
    }
    Invoke-Pester -Configuration $pConfig
}

task Configure {

    $configFile = Get-BuildConfigurationFile
    $pLocation = Get-ProjectRoot
    $xPath = 'Data/Table/Item[@Key="Project"]'
    $x = Import-PsdXml $configFile

    Write-Build Blue "$CurrentIndent Set Project Path to '$pLocation' in $configFile"

    $project = Get-Psd $x $xPath
    $project.Path = $pLocation
    Set-Psd -Xml $x -XPath $xPath -Value $project

    Export-PsdXml -Path $configFile -Xml $x

    Write-Build Blue 'Checking paths and locations'
    $config = Get-BuildConfiguration

    $projectPaths = @(
        $config.Staging.Path,
        "$($config.Staging.Path)/$($config.Project.Name)",
        $config.Artifact.Path,
        $config.Docs.Path
    )

    foreach ($p in $projectPaths) {
        if (-not(Test-Path $p)) {
            Write-Build DarkBlue "$CurrentIndent Creating $p directory"
            New-Item -Path $p -ItemType Directory
        } else {
            Write-Build Green "$CurrentIndent $p already exists"
        }

    }
},
remove_temp_repository

task CodeCoverage {
    $config = Get-BuildConfiguration
    $pester_config_file = $config.Tests.Config.Coverage

    if (-not(Test-Path $pester_config_file)) {
        Write-Build Red "$CurrentIndent Could not find Code Coverage configuration at Tests.Config.Coverage -> $pester_config_file"
    } else {
        $PesterConfig = New-PesterConfiguration -Hashtable (Import-Psd $pester_config_file)

        $mod = Join-Path -Path $config.Project.Path -ChildPath $config.Project.Modules.Root.Module
        Import-Module $mod -Force
        $PesterResult = Invoke-Pester -Configuration $PesterConfig # passthru must be set to $true
        Export-Clixml -InputObject $PesterResult -Path 'out/pester_invocation_results-codecoverage.xml'
    }
}


task new_markdown_help {
    $config = Get-BuildConfiguration
    if (-not(Test-Path $config.Docs.Help)) { mkdir $config.Docs.Help -Force | Out-Null }
    Write-Build DarkBlue "$CurrentIndent Creating markdown help files in $($config.Docs.Help)"

    Import-Module (Resolve-Path $config.Project.Modules.Root.Manifest) -Force

    <#HACK:
    In order to generate a "Module page", I need to pass in `-WithModulePage`.  And if I want to add
      the onlineversionurl I need to supply the `-Command`, However they cannot be used together.
      So, I'm running `New-MarkdownHelp` twice.  The first time to make the module page, and the second
      time for each command that has the `-Force` set to overwrite them
    #>
    Write-Build DarkBlue ' - Generating markdown help pages and a module page'
    New-MarkdownHelp -Module infraspective -WithModulePage -OutputFolder $config.Docs.Help -Force

    foreach ($cmd in (Get-Command -Module Infraspective | Select-Object -ExpandProperty Name)) {
        $doc_options = @{
            Force                 = $true
            Command               = ''
            OutputFolder          = $config.Docs.Help
            AlphabeticParamsOrder = $true
            ExcludeDontShow       = $true
            OnlineVersionUrl      = 'https://github.com/aldrichtr/infraspective/blob/main/docs/help/'
            Encoding              = [System.Text.Encoding]::UTF8
        }
        $doc_options.Command = $cmd
        $doc_options.OnlineVersionUrl += "$cmd.md"
        Write-Build DarkBlue "$CurrentIndent   - Updating the $cmd help file metadata"
        New-MarkdownHelp @doc_options
    }
}


task update_markdown_help {
    $config = Get-BuildConfiguration
    if (-not(Test-Path $config.Docs.Help)) {
        Write-Build DarkRed "$CurrentIndent Markdown help folder '$($config.Docs.Help) does not exist!"
    }

    Import-Module (Resolve-Path $config.Project.Modules.Root.Manifest) -Force

    foreach ($cmd in (Get-Command -Module Infraspective | Select-Object -ExpandProperty Name)) {
        $doc_options = @{
            Path                  = (Join-Path $config.Docs.Help "$cmd.md")
            AlphabeticParamsOrder = $true
            UpdateInputOutput     = $true
            ExcludeDontShow       = $true
            LogPath               = (Join-Path $config.Artifact.Path "platyps_$(Get-Date -Format 'yyyy.MM.dd.HH.mm').log")
            Encoding              = [System.Text.Encoding]::UTF8
        }

        Write-Build DarkBlue "$CurrentIndent Updating help for $cmd"
        Update-MarkdownHelp @doc_options
    }
}

task stage_external_help {
    $config = Get-BuildConfiguration
    Write-Build DarkBlue "$CurrentIndent Generating the external help from the docs in $($config.Docs.Help) folder"
    New-ExternalHelp $config.Docs.Help -OutputPath (
        Join-Path $config.Staging.Path 'infraspective\en-US') -Force | Out-Null
}

task update_stage_manifest_version {
    $config = Get-BuildConfiguration
    $version_info = dotnet-gitversion | ConvertFrom-Json

    $man = Test-ModuleManifest -Path $config.Project.Modules.Root.Manifest

    $previous_version = $man.Version
    $current_version = $version_info.MajorMinorPatch
    $stage_man = Join-Path $config.Staging.Path -ChildPath 'infraspective' -AdditionalChildPath 'infraspective.psd1'

    Write-Build DarkBlue "$CurrentIndent Updating staged module from $previous_version to version $current_version"
    Update-Metadata -Path $stage_man -PropertyName 'ModuleVersion' -Value $current_version
}


task update_source_manifest_version {
    $config = Get-BuildConfiguration
    $version_info = dotnet-gitversion | ConvertFrom-Json

    $man = Test-ModuleManifest $config.Project.Modules.Root.Manifest

    $previous_version = $man.Version
    $current_version = $version_info.MajorMinorPatch

    Write-Build DarkBlue "$CurrentIndent Updating source module from $previous_version to version $current_version"
    Update-Metadata -Path $man.Path -PropertyName 'ModuleVersion' -Value $current_version
}

task update_doc_help_version {
    $config = Get-BuildConfiguration
    $version_info = dotnet-gitversion | ConvertFrom-Json
    $current_version = $version_info.MajorMinorPatch

    Get-ChildItem $config.Docs.Help -Filter '*.md' | ForEach-Object {
        if (Select-String -Path $_ -Pattern '^Help Version:') {
            Write-Build DarkBlue "$CurrentIndent Updating help $($_.Name) to version $current_version"
            (Get-Content $_) -replace '^Help Version: .*' , "Help Version: $current_version" |
                Set-Content -Path $_ -Encoding UTF8NoBOM
            }
        }
}

task update_readme_version {
    $config = Get-BuildConfiguration
    $version_info = dotnet-gitversion | ConvertFrom-Json
    $current_version = $version_info.MajorMinorPatch
    $readme = Join-Path $config.Project.Path 'README.md'

    Write-Build DarkBlue "$CurrentIndent Updating Readme to version $current_version"
    (Get-Content $readme) -replace '^Version: .*', "Version: $current_version" |
            Set-Content -Path $readme -Encoding UTF8NoBOM
}

task bump_version {
    Write-Build DarkBlue 'Incrementing version based on git tags'
}, update_source_manifest_version,
update_doc_help_version,
update_readme_version

#synopsis: Generate a module from source
task Stage Clean,
make_staging_module,
make_staging_manifest,
stage_external_help


task Package register_local_artifact_repository,
publish_to_temp_repository
