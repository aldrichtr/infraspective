
Describe 'Testing private function Write-Result' -Tag @('unit', 'Write', 'Result') {
    Context "When the Output Scope level is 'Test'" {
        Context 'When the input Scope is <Scope>' -ForEach @(
            BeforeAll {
                $global:audit_state = @{
                    Depth         = 0 # removes the "leader" from the output
                    Configuration = @{
                        Output = @{
                            Scope     = 'Test'
                            StatusMap = @{
                                Leader    = '| '
                                Passed  = @{
                                    Foreground = 'White'
                                    Background = 'Black'
                                    Format = '[${fg:green}<%= $Type %>${fg:white}] - {${fg:blue}<%= $Scope %>${fg:white}} - <%= $Name %>: <%= $Title %>'
                                    Reset = $true
                                    Render = $true
                                }
                            }
                        }
                    }
                }
                #HACK:  There is something in the Pester output that is messing with the
                #      output.  It is not set until after the first call to `New-Text`
                $text = New-Text "Hello World" -ForegroundColor White -BackgroundColor Black
            }
            AfterAll {
                Remove-Variable -Scope 'Global' -Name 'audit_state'
            }
            @{ Scope = 'Test' },
            @{ Scope = 'Block' },
            @{ Scope = 'Control' },
            @{ Scope = 'Grouping' },
            @{ Scope = 'Checklist' },
            @{ Scope = 'File' }
        ) {
            It 'It should output [Passed] with formatting' {
                $expected = @(
                    "`e[97m`e[40m",  # White on Black
                    "[",
                    "`e[92m",        # green on black
                    "Passed",
                    "`e[97m",        # white on black
                    "] - {",
                    "`e[94m",        # blue on black
                    $Scope,
                    "`e[97m",        # white on black
                    "} - Result Test: The test passed",
                    "`e[49m`e[39m"
                ) -join ''

                $result = Write-Result $Scope 'Passed' -Data @{
                    Name  = 'Result Test'
                    Title = 'The test passed'
                } 6>&1

                $result[0] | Should -Be $expected
            }
        }
    }
}
