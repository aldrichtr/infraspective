
Describe 'Testing the Service specification' -Tag @('unit', 'Service', 'poshspec') {
    Context 'Service' {
        BeforeAll {
            Mock Invoke-PoshspecExpression -ModuleName infraspective {
                return $InputObject
            }

            $results = Service w32time Status { Should -Be Running }
        }
        It "Should return the correct test Name" {
            $results.Name | Should -Be "Service property 'Status' for 'w32time' Should -Be Running"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-Service -Name 'w32time' | Select-Object -ExpandProperty 'Status' | Should -Be Running"
        }
    }
}
