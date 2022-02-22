
Describe 'Testing the Registry specification' -Tag @('unit', 'Registry', 'poshspec') {
    Context 'Registry w/o Properties' {
        BeforeAll {
            Mock Invoke-PoshspecExpression -ModuleName infraspective {
                return $InputObject
            }
            $results = Registry HKLM:\SOFTWARE\Microsoft\Rpc\ClientProtocols { Should -Exist }
        }
        It "Should return the correct test Name" {
            $results.Name | Should -Be "Registry 'ClientProtocols' Should -Exist"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "'HKLM:\SOFTWARE\Microsoft\Rpc\ClientProtocols' | Should -Exist"
        }
    }

    Context 'Registry with Properties' {
        BeforeAll {
            Mock Invoke-PoshspecExpression -ModuleName infraspective {
                return $InputObject
            }
            $results = Registry HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\ "NV Domain" { Should -Be cnb.Corp.com }
        }
        It "Should return the correct test Name" {
            $results.Name | Should -Be "Registry property 'NV Domain' for 'Parameters' Should -Be cnb.Corp.com"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\' | Select-Object -ExpandProperty 'NV Domain' | Should -Be cnb.Corp.com"
        }
    }
}
