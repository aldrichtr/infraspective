
Describe "Testing private function Write-Result" -Tag @('unit', 'Write', 'Result') {
    Context "When the configured Scope is 'Test'" {
        BeforeAll {
            $global:audit_state = @{
                Depth         = 0 # removes the "leader" from the output
                Configuration = @{
                    Output = @{
                        Scope     = 'Test'
                        StatusMap = @{
                            Passed = @{
                                Color  = 'Green'
                                Format = "[Passed]"
                                Reset  = $true
                            }
                        }
                    }
                }
            }
        }
        AfterAll {
            Remove-Variable -Scope 'Global' -Name 'audit_state'
        }
        Context "When the input Scope is <Scope>" -ForEach @(
            @{ Scope = 'Test' },
            @{ Scope = 'Block' },
            @{ Scope = 'Control' },
            @{ Scope = 'Grouping' },
            @{ Scope = 'Checklist' },
            @{ Scope = 'File' }
        ) {
            It "It should output [Passed] with formatting" {
                $expected = @(
                    "$($PSStyle.Foreground.Green)",
                    "[Passed]",
                    "$($PSStyle.Reset)",
                    " The test passed") -join ''
                $result = Write-Result $Scope 'Passed' "The test passed" 6>&1
                $result | Should -MatchExactly ([regex]::escape($expected))
            }
        }
    }
}
