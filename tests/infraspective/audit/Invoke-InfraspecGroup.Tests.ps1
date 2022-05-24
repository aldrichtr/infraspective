
$options = @{
    Name = "Testing the public function Invoke-InfraspecGroup"
    Tag  = @('unit', 'Invoke', 'InfraspecGroup', 'Group')
}
Describe @options {
    BeforeAll {
        Mock Write-Log { <#do nothing#> }
        Mock Write-Result -ModuleName infraspective { <#do nothing#> }
        Mock Invoke-Pester -ModuleName infraspective -ParameterFilter { $Container -like "*" } -Verifiable
        function Invoke-PassingControl {
            $r = [PSCustomObject]@{
                PSTypeName = 'Infraspective.Control.ResultInfo'
                Result     = 'Passed'
            }
            return $r
        }

        function Invoke-FailingControl {
            $r = [PSCustomObject]@{
                PSTypeName = 'Infraspective.Control.ResultInfo'
                Result     = 'Failed'
            }
            return $r
        }

    }
    Context "When invoking a Group" {
        BeforeAll {
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

            $group = Invoke-InfraspecGroup "Group test" { $child } -Title "A test Group" -Description "Server"
        }

        AfterAll {
            Remove-Variable -Scope 'Global' -Name 'audit_state'
        }

        It "It should return an 'Infraspective.Group.ResultInfo' object" {
            $group.PSObject.TypeNames[0] | Should -Be 'Infraspective.Group.ResultInfo'
        }

        It "It should set the Name parameter" {
            $group.Name | Should -Be "Group test"
        }

        It "It should set the Title parameter" {
            $group.Title | Should -Be "A test Group"
        }

        It "It should set the Description to 'Server'" {
            $group.Description | Should -Be "Server"
        }
    }
    Context "When multiple Controls are within the Grouping with failures" {
        BeforeAll {
            $global:audit_state = @{
                Depth         = 0
                Configuration = @{
                    Output = @{
                        Scope = 'Test'
                    }
                }
            }


            $group = Invoke-InfraspecGroup "Group test" {
                Invoke-FailingControl
                Invoke-FailingControl
                Invoke-PassingControl
            } -Title "A test Group with two failures" -Description "Server"
        }

        AfterAll {
            Remove-Variable -Scope 'Global' -Name 'audit_state'
        }

        It "It should have a Result of Failed" {
            $group.Result | Should -BeExactly 'Failed'
        }

        It "It should have a TotalCount of 3" {
            $group.TotalCount | Should -BeExactly 3
        }

        It "It should have a FailedCount of 2" {
            $group.FailedCount | Should -BeExactly 2
        }

        It "It should have two Controls in the Failed Array" {
            $group.Controls.Failed.Count | Should -BeExactly 2
        }

        It "It should have a PassedCount of 1" {
            $group.PassedCount | Should -BeExactly 1
        }

        It "It should have one Control in the Passed Array" {
            $group.Controls.Passed.Count | Should -BeExactly 1
        }
    }
}
