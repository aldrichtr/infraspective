
$options = @{
    Name = "Testing the public function Invoke-InfraspecControl"
    Tag  = @('unit', 'Invoke', 'InfraspecControl', 'Control')
}
Describe @options {
    Context "When invoking a Control" {
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

            $check = Invoke-InfraspecControl "Control test" { $child } -Title "A test Control" -Resource "Server"
        }

        AfterAll {
            Remove-Variable -Scope 'Global' -Name 'state'
        }

        It "It should return an 'Infraspective.Control.ResultInfo' object" {
            $check.PSObject.TypeNames[0] | Should -Be 'Infraspective.Control.ResultInfo'
        }

        It "It should set the Name parameter" {
            $check.Name | Should -Be "Control test"
        }

        It "It should set the Title parameter" {
            $check.Title | Should -Be "A test Control"
        }

        It "It should set the Resource to 'Server'" {
            $check.Resource | Should -Be "Server"
        }
    }
}
