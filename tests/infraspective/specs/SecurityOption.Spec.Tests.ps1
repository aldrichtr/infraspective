
Describe 'Testing the SecurityOption specification' -Tag @('unit', 'SecurityOption', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    Context 'SecurityOption' {
        BeforeAll {
            $results = SecurityOption 'Accounts: Administrator account status' { Should -Be 'Disabled' }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be  "SecurityOption 'Accounts: Administrator account status' Should -Be 'Disabled'"
        }
            
        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "GetSecurityPolicy -Category 'Accounts_Administrator_account_status' | Should -Be 'Disabled'"
        }
    }

}
