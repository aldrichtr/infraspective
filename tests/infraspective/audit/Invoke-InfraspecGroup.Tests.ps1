
$options = @{
    Name = "Testing the public function Invoke-InfraspecGroup"
    Tag  = @('unit', 'Invoke', 'InfraspecGroup', 'Group')
}
Describe @options {
    Context "When invoking a Group" {
        BeforeAll {
            Mock Write-Log { <#do nothing#> }
            Mock Write-Result { <#do nothing#> }

            $global:state = @{
                Depth         = 0
                Configuration = @{}
            }

            $child = @{
                Container = $null
            }

            $check = Invoke-InfraspecGroup "Group test" { $child } -Title "A test Group" -Description "Server"
        }

        AfterAll {
            Remove-Variable -Scope 'Global' -Name 'state'
        }

        It "It should return an 'Infraspective.Group.ResultInfo' object" {
            $check.PSObject.TypeNames[0] | Should -Be 'Infraspective.Group.ResultInfo'
        }

        It "It should set the Name parameter" {
            $check.Name | Should -Be "Group test"
        }

        It "It should set the Title parameter" {
            $check.Title | Should -Be "A test Group"
        }

        It "It should set the Description to 'Server'" {
            $check.Description | Should -Be "Server"
        }
    }
}
