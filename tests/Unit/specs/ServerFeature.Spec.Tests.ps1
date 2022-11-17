
Describe 'Testing the ServerFeature specification' -Tag @('unit', 'ServerFeature', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    Context 'ServerFeature' {
        BeforeAll {
            $results = ServerFeature 'Telnet-Client' 'Installed' { Should -Be $False }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "ServerFeature property 'Installed' for 'Telnet-Client' Should -Be `$False"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "GetFeature -Name Telnet-Client | Select-Object -ExpandProperty 'Installed' | Should -Be $False"
        }
    }

}
