
Describe 'Testing the LocalGroup specification' -Tag @('unit', 'LocalGroup', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -ModuleName infraspective {
            return $InputObject
        }
    }

    Context 'LocalGroup' {
        BeforeAll {
            $results = LocalGroup 'Administrators' { Should -Exist }
        }

        It 'Should return a correct test name' {
            $results.Name | Should -Be "LocalGroup 'Administrators' Should -Exist"
        }

        It 'Should return a correct text expression' {
            $results.Expression | Should -Be 'Get-CimInstance -ClassName Win32_Group -Filter "Name = ''Administrators''" | Should -Exist'
        }
    }

}
