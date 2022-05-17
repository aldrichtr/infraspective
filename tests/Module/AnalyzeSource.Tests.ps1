

BeforeDiscovery {
    $sourceFiles = Get-ChildItem "$BuildRoot\source" -Filter "*.ps1" -Recurse | Get-SourceItem
    # Gather rules during discovery, so we can use the 'foreach' below
    $analyzerRules = Get-ScriptAnalyzerRule
}

Describe "Validate <_.Visibility> component <_.Name> passes ScriptAnalyzer rules" -Tag @('analyze') -ForEach $sourceFiles {
    BeforeAll {
        Import-Module PSScriptAnalyzer

        # Gather results during run, so we can use them inside the 'It'
        $analysis = Invoke-ScriptAnalyzer $_.Path -Settings "$BuildRoot\PSScriptAnalyzerSettings.psd1"

    }

    BeforeEach {
        # Make the result "pretty formatted"
        $FailureTable = ''
    }
    It "Should be a valid path" {
        Test-Path $_.Path | Should -BeTrue
    }

    It "Should pass the '<_.RuleName>' Rule" -TestCases $analyzerRules {
        $analysis | Should -Pass $_
    }
}
