
Describe 'Testing the TcpPort specification' -Tag @('unit', 'TcpPort', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }

    Context 'TcpPort' {
        BeforeAll {
            $results = TcpPort localhost 80 PingSucceeded { Should -Be $True }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "TcpPort property 'PingSucceeded' for 'localhost' at '80' Should -Be `$True"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Test-NetConnection -ComputerName localhost -Port 80 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'PingSucceeded' | Should -Be $True"
        }
    }

}
