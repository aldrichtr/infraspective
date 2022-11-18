
Describe 'Testing the Interface specification' -Tag @('unit', 'Interface', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -ModuleName infraspective {
            return $InputObject
        }
    }

    Context 'Interface' {
        BeforeAll {
            $results = Interface ethernet0 { Should -Exist }
        }
        It 'Should return a correct test name' {
            $results.Name | Should -Be "Interface 'ethernet0' Should -Exist"
        }

        It 'Should return a correct text expression' {
            $results.Expression | Should -Be "Get-NetAdapter -Name 'ethernet0' -ErrorAction SilentlyContinue | Should -Exist"
        }
    }

    Context 'Interface w/ properties' {
        BeforeAll {
            $results = interface ethernet0 status { Should -Be 'up' }
        }
            
        It 'Should return a correct test name' {
            $results.Name | Should -Be "Interface property 'status' for 'ethernet0' Should -Be 'up'"
        }

        It 'Should return a correct text expression' {
            $results.Expression | Should -Be "Get-NetAdapter -Name 'ethernet0' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'status' | Should -Be 'up'"
        }
    }

}
