
Describe 'Testing the LocalUser specification' -Tag @('unit', 'LocalUser', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    Context 'LocalUser' {
        BeforeAll {
            $results = LocalUser Guest Disabled { Should -Be $True }
        }
            
        It "Should return the correct test Name" {
            $results.Name | Should -Be "LocalUser property 'Disabled' for 'Guest' Should -Be `$True"
        }
        
        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-CimInstance -ClassName Win32_UserAccount -filter `"LocalAccount=True AND Name='Guest'`" | Select-Object -ExpandProperty 'Disabled' | Should -Be $True"
        }
    }

}
