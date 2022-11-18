
Describe 'Testing the SoftwareProduct specification' -Tag @('unit', 'SoftwareProduct', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    Context 'SoftwareProduct' {
        BeforeAll {
            $results = SoftwareProduct 'Microsoft .NET Framework 4.6.1' { Should -Exist }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "SoftwareProduct 'Microsoft .NET Framework 4.6.1' Should -Exist"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "@('HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') | Where-Object { Test-Path `$_ } | Get-ItemProperty | Where-Object DisplayName -Match 'Microsoft .NET Framework 4.6.1' | Should -Exist"
        }
    }

    Context 'SoftwareProduct w/Property' {
        BeforeAll {
            $results = SoftwareProduct 'Microsoft .NET Framework 4.6.1' DisplayVersion { Should -Be 4.6.01055 }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "SoftwareProduct property 'DisplayVersion' for 'Microsoft .NET Framework 4.6.1' Should -Be 4.6.01055"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "@('HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') | Where-Object { Test-Path `$_ } | Get-ItemProperty | Where-Object DisplayName -Match 'Microsoft .NET Framework 4.6.1' | Select-Object -ExpandProperty 'DisplayVersion' | Should -Be 4.6.01055"
        }
    }


}
