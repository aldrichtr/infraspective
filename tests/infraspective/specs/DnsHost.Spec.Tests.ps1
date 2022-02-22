
Describe 'Testing the DnsHost specification' -Tag @('unit', 'DnsHost', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    
    Context 'Dnshost' {
        BeforeAll {
            $results = DnsHost www.google.com { Should -Exist }
        }
            
        It "Should return the correct test Name" {
            $results.Name | Should -Be "DnsHost 'www.google.com' Should -Exist"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Resolve-DnsName -Name www.google.com -DnsOnly -NoHostsFile -ErrorAction SilentlyContinue | Should -Exist"
        }
    }

}
