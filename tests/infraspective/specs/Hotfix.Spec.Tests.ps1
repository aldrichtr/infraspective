
Describe 'Testing the Hotfix specification' -Tag @('unit', 'Hotfix', 'poshspec') {
    Context 'Hotfix' {
        BeforeAll {
            Mock Invoke-PoshspecExpression -ModuleName infraspective {
                return $InputObject
            }
            $results = Hotfix KB1234567 { Should -Exist }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "Hotfix 'KB1234567' Should -Exist"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-HotFix -Id KB1234567 -ErrorAction SilentlyContinue | Should -Exist"
        }
    }
}
