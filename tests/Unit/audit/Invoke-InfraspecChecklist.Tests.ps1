
$options = @{
    Name = "Testing the public function Invoke-InfraspecChecklist"
    Tag  = @('unit', 'Invoke', 'InfraspecChecklist', 'Checklist')
}
Describe @options {
    BeforeAll {
        Mock Write-CustomLog -ModuleName infraspective { <#do nothing#> }
        Mock Write-Result -ModuleName infraspective { <#do nothing#> }
        Mock Invoke-Pester -ModuleName infraspective -ParameterFilter { $Container -like '*' } -Verifiable

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
    Context "When invoking a Checklist" {
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

    Context "When multiple Controls and Groupings are within the Checklist with mixed results" {
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
            $passed += 1 # for ControlThree
            $failed = $GroupOne.failed + $GroupTwo.failed + $GroupThree.failed
            $failed += 2 # for ControlOne and ControlTwo
            $skipped = $GroupOne.skipped + $GroupTwo.skipped + $GroupThree.skipped
            $total = $GroupOne.total + $GroupTwo.total + $GroupThree.total
            $total += 3 # for ControlOne ControlTwo and ControlThree

            $group = Invoke-InfraspecChecklist "Group test" {
                Invoke-TestControlResult -Result 'Failed'
                Invoke-TestControlResult -Result 'Failed'
                Invoke-TestControlResult -Result 'Passed'
                Invoke-TestGroupResult @GroupOne
                Invoke-TestGroupResult @GroupTwo
                Invoke-TestGroupResult @GroupThree
            } -Title "A test Checklist with groups and controls" -Version "1.0.0"
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
