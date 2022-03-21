
Describe 'Testing the Volume specification' -Tag @('unit', 'Volume', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    Context 'Volume' {
        BeforeAll {
            $results = Volume 'C' DriveType { Should -Be 'Fixed' }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "Volume property 'DriveType' for 'C' Should -Be 'Fixed'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "GetVolume -Name 'C' | Select-Object -ExpandProperty 'DriveType' | Should -Be 'Fixed'"
        }
    }

}
