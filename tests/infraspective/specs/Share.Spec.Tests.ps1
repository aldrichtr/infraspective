
Describe 'Testing the Share specification' -Tag @('unit', 'Share', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -ModuleName infraspective {
            return $InputObject
        }
    }

    Context 'Share' {
        BeforeAll {
            $results = Share 'MyShare' { Should -Exist }
        }
        
        It 'Should return a correct test name' {
            $results.Name | Should -Be "Share 'MyShare' Should -Exist"
        }

        It 'Should return a correct text expression' {
            $results.Expression | Should -Be 'Get-CimInstance -ClassName Win32_Share -Filter "Name = ''MyShare''" | Should -Exist'
        }
    }

}
