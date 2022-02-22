
Describe 'Testing the Package specification' -Tag @('unit', 'Package', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }

    Context 'Package' {
        BeforeAll {
            $results = Package 'Microsoft Visual Studio Code' { Should -Exist }
        }
            
        It 'Should return a correct test name' {
            $results.Name | Should -Be "Package 'Microsoft Visual Studio Code' Should -Exist"
        }

        It 'Should return a correct text expression' {
            $results.Expression | Should -Be 'Get-Package -Name "Microsoft Visual Studio Code" -ErrorAction SilentlyContinue | Select-Object -First 1 | Should -Exist'
        }
    }

    Context 'Package w/ properties' {
        BeforeAll {
            $results = Package 'Microsoft Visual Studio Code' version { Should -Be '1.1.0' }
        }
            
        It 'Should return a correct test name' {
            $results.Name | Should -Be "Package property 'version' for 'Microsoft Visual Studio Code' Should -Be '1.1.0'"
        }

        It 'Should return a correct text expression' {
            $results.Expression | Should -Be "Get-Package -Name ""Microsoft Visual Studio Code"" -ErrorAction SilentlyContinue | Select-Object -First 1 | Select-Object -ExpandProperty 'version' | Should -Be '1.1.0'"
        }
    }

    Context 'Package w/Single Quotes' {
        BeforeAll {
            $results = Package "Name 'subname'" { Should -Exist }
        }
            
        It 'Should return a correct test name' {
            $results.Name | Should -Be "Package 'Name 'subname'' Should -Exist"
        }

        It 'Should return a correct text expression' {
            $results.Expression | Should -Be "Get-Package -Name ""Name 'subname'"" -ErrorAction SilentlyContinue | Select-Object -First 1 | Should -Exist"
        }
    }
}
