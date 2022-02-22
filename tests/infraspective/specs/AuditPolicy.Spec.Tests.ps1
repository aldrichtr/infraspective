
Describe 'Testing the AuditPolicy specification' -Tag @('unit', 'AuditPolicy', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    Context 'AuditPolicy' {
        BeforeAll {
            $results = AuditPolicy System 'Security System Extension' { Should -Be 'Success' }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "AuditPolicy 'Security System Extension' Should -Be 'Success'"
        }
            
        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "GetAuditPolicy -Category 'System' -Subcategory 'Security System Extension' | Should -Be 'Success'"
        }
    }

}
