
Describe 'Testing the Firewall specification' -Tag @('unit', 'Firewall', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    Context 'Firewall' {
        BeforeAll {
            $results = Firewall putty.exe Action { Should -Be 'Allow' }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "Firewall property 'Action' for 'putty.exe' Should -Be 'Allow'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-NetFirewallRule -DisplayName 'putty.exe' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'Action' | Should -Be 'Allow'"
        }
    }


}
