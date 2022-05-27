
$options = @{
    Name = "Testing the public function Invoke-InfraspecGroup"
    Tag  = @('unit', 'Invoke', 'InfraspecGroup', 'Group')
}
Describe @options {
    BeforeAll {
        Mock Write-Log { <#do nothing#> }
        Mock Write-Result -ModuleName infraspective { <#do nothing#> }
        Mock Invoke-Pester -ModuleName infraspective -ParameterFilter { $Container -like "*" } -Verifiable
        function Invoke-TestControlResult {
            <#
            .SYNOPSIS
                create a fake test result
            .DESCRIPTION
                create a fake test result based on parameters
            #>
            [CmdletBinding()]
            param(
                [Parameter()][string]$Result
            )
            $r = [PSCustomObject]@{
                PSTypeName = 'Infraspective.Control.ResultInfo'
                Result     = $Result
            }
            return $r
        }

        function Invoke-TestGroupResult {
            <#
            .SYNOPSIS
                create a fake test result
            .DESCRIPTION
                create a fake test result based on parameters
            #>
            [CmdletBinding()]
            param(
                [Parameter()][string]$result,
                [Parameter()][int]$passed,
                [Parameter()][int]$failed,
                [Parameter()][int]$skipped,
                [Parameter()][int]$total
            )
            $r = [PSCustomObject]@{
                PSTypeName   = 'Infraspective.Group.ResultInfo'
                Result       = $result
                PassedCount  = $passed
                FailedCount  = $failed
                SkippedCount = $skipped
                TotalCount   = ($passed + $failed + $skipped)
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
    Context "When multiple Controls are within the Grouping with mixed results" -ForEach @(
        @{
            total   = 10
            failed  = 5
            passed  = 3
            skipped = 2
        }) {
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
                1..$failed | Foreach-Object {
                    Invoke-TestControlResult -Result 'Failed'
                }
                1..$passed | Foreach-Object {
                    Invoke-TestControlResult -Result 'Passed'
                }
                1..$skipped | Foreach-Object {
                    Invoke-TestControlResult -Result 'Skipped'
                }
            } -Title "A test Group with two failures" -Description "Server"
        }

        AfterAll {
            Remove-Variable -Scope 'Global' -Name 'audit_state'
        }

        It "It should have a Result of Failed" {
            $group.Result | Should -BeExactly 'Failed'
        }

        It "It should have a TotalCount of <total>" {
            $group.TotalCount | Should -BeExactly $total
        }

        It "It should have a FailedCount of <failed>" {
            $group.FailedCount | Should -BeExactly $failed
        }

        It "It should have <failed> Controls in the Failed Array" {
            $group.Controls.Failed.Count | Should -BeExactly $failed
        }

        It "It should have a PassedCount of <passed>" {
            $group.PassedCount | Should -BeExactly $passed
        }

        It "It should have <passed> Controls in the Passed Array" {
            $group.Controls.Passed.Count | Should -BeExactly $passed
        }

        It "It should have a SkippedCount of <skipped>" {
            $group.SkippedCount | Should -BeExactly $skipped
        }

        It "It should have <skipped> Controls in the Skipped Array" {
            $group.Controls.Skipped.Count | Should -BeExactly $skipped
        }
    }
    Context "When multiple Controls and Groupings are within the Grouping with mixed results" {
        BeforeAll {
            $global:audit_state = @{
                Depth         = 0
                Configuration = @{
                    Output = @{
                        Scope = 'Test'
                    }
                }
            }

            $GroupOne = @{ Result = 'Failed'; passed = 10; failed = 2; skipped = 1; total = 13 }
            $GroupTwo = @{ Result = 'Failed'; passed = 14; failed = 5; skipped = 1; total = 20 }
            $GroupThree = @{ Result = 'Passed'; passed = 10; failed = 0; skipped = 1; total = 11 }

            $passed = $GroupOne.passed + $GroupTwo.passed + $GroupThree.passed
            $failed = $GroupOne.failed + $GroupTwo.failed + $GroupThree.failed
            $skipped = $GroupOne.skipped + $GroupTwo.skipped + $GroupThree.skipped
            $total = $GroupOne.total + $GroupTwo.total + $GroupThree.total


            $group = Invoke-InfraspecGroup "Group test" {
                Invoke-TestGroupResult @GroupOne
                Invoke-TestGroupResult @GroupTwo
                Invoke-TestGroupResult @GroupThree
            } -Title "A test Group with two failing groups" -Description "Server"
        }

        AfterAll {
            Remove-Variable -Scope 'Global' -Name 'audit_state'
        }

        It "It should have a Result of Failed" {
            $group.Result | Should -BeExactly 'Failed'
        }

        It "It should have a TotalCount of <total>" {
            $group.TotalCount | Should -BeExactly $total
        }

        It "It should have a FailedCount of <failed>" {
            $group.FailedCount | Should -BeExactly $failed
        }

        It "It should have a PassedCount of <passed>" {
            $group.PassedCount | Should -BeExactly $passed
        }

        It "It should have a SkippedCount of <skipped>" {
            $group.SkippedCount | Should -BeExactly $skipped
        }
    }
}
