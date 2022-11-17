
Describe 'Testing the Http specification' -Tag @('unit', 'Http', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    
    Context 'HTTP' {
        BeforeAll {
            $results = Http http://localhost StatusCode { Should -Be 200 }
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "Http property 'StatusCode' for 'http://localhost' Should -Be 200"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Invoke-WebRequest -Uri 'http://localhost' -UseBasicParsing -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'StatusCode' | Should -Be 200"
        }
    }
}
