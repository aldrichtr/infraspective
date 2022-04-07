

BeforeDiscovery {
    $sourceFiles = Get-ChildItem $Source.Path -Filter "*.ps1" -Recurse | Get-SourceItem
    # Gather rules during discovery, so we can use the 'foreach' below
    $analyzerRules = Get-ScriptAnalyzerRule
}



foreach ($source in $sourceFiles) {
    $Options = @{
        Name    = "Testing $($source.Visibility) component $($source.Name)"
        Tags    = @(
            'analyze',
            $source.Verb,
            $source.Noun
        )
        ForEach = @{
            'source' = $source
        }
    }
    Describe @Options {
        Context "Validate function passes ScriptAnalyzer rules" {

            BeforeAll {
                Import-Module PSScriptAnalyzer

                # Gather results during run, so we can use them inside the 'It'
                $analysis = Invoke-ScriptAnalyzer $source.Path

            }

            BeforeEach {
                # Make the result "pretty formatted"
                $FailureTable = ''
            }
            It "Should be a valid path" {
                Test-Path $source.Path | Should -BeTrue
            }

            foreach ($rule in $analyzerRules) {
                # the '-TestCases' here allows us to "pass" the rule object
                # from the 'Discovery' phase to the 'Run' phase
                It "Should pass the '<rule.RuleName>' Rule" -TestCases @{
                    'rule' = $rule
                } {
                    $analysis | Should -Pass $rule
                }
            }
        }
    }
}
