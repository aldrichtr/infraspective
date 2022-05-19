
$options = @{
    Name = "Testing the public function Invoke-InfraspecChecklist"
    Tag  = @('unit', 'Invoke', 'InfraspecChecklist', 'Checklist')
}
Describe @options {
    Context "When invoking a Checklist" {
        BeforeAll {
            Mock Write-Log { <#do nothing#> }
            Mock Write-Result -ModuleName 'infraspective' { <#do nothing#> }

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

            $check = Invoke-InfraspecChecklist "Checklist test" { $child } -Title "A test checklist" -Version "0.1"
        }

        AfterAll {
            Remove-Variable -Scope 'Global' -Name 'audit_state'
        }

        It "It should return an 'Infraspective.Checklist.ResultInfo' object" {
            $check.PSObject.TypeNames[0] | Should -Be 'Infraspective.Checklist.ResultInfo'
        }

        It "It should set the Name parameter" {
            $check.Name | Should -Be "Checklist test"
        }

        It "It should set the Title parameter" {
            $check.Title | Should -Be "A test checklist"
        }

        It "It should set the version to '0.1'" {
            $check.Version | Should -Be "0.1"
        }
    }
}
