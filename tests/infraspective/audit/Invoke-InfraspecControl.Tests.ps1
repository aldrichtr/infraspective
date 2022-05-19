
$options = @{
    Name = "Testing the public function Invoke-InfraspecControl"
    Tag  = @('unit', 'Invoke', 'InfraspecControl', 'Control')
}
Describe @options {
    Context "When invoking a Control" {
        BeforeAll {
            Remove-Alias -Name Control
            Mock Write-Log { <#do nothing#> }
            Mock Invoke-Pester -ModuleName infraspective -ParameterFilter { $Container -like "*"} -Verifiable
            Mock Write-Result -ModuleName infraspective { <#do nothing#> } -Verifiable
            $global:audit_state = @{
                Depth         = 0
                Configuration = @{
                    Output = @{
                        Scope = 'Test'
                    }
                }
            }

            $child = @{
                Container = $null
            }

            $control_options = @{
                Name        = "(Name)UnitTest"
                Title       = "(Title)UnitTest of Invoke-InfraspecControl"
                Impact      = "(Impact)low"
                Reference   = "(Reference)CVE:000"
                Tags        = "(Tags)unittest"
                Resource    = "(Resource)Pester"
                Description = "(Description)Pester UnitTest of Invoke-InfraspecControl"
                Body        = { $child }
            }
            $check = Invoke-InfraspecControl @control_options
        }

        AfterAll {
            Remove-Variable -Scope 'Global' -Name 'audit_state'
        }


        It "Should call Write-Result" {
            Should -InvokeVerifiable
        }

        It "It should return an 'Infraspective.Control.ResultInfo' object" {
            $check.PSObject.TypeNames[0] | Should -Be 'Infraspective.Control.ResultInfo'
        }

        It "It should set the Name parameter" {
            $check.Name | Should -Be $control_options.Name
        }

        It "It should set the Title parameter" {
            $check.Title | Should -Be $control_options.Title
        }

        It "It should set the Resource parameter" {
            $check.Resource | Should -Be $control_options.Resource
        }
    }
}
