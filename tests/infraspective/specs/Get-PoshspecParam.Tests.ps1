

Describe 'Testing private function Get-PoshspecParam' -Tags @('unit', 'Get', 'PoshspecParam', 'poshspec') {
    Context 'One Parameter' {
        BeforeAll {
            $options = @{
                TestName       = 'MyTest'
                TestExpression = { Get-Item '$Target' }
                Target         = 'Name'
                Should         = { Should -Exist }
            }

            $results = Get-PoshspecParam @options
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "MyTest 'Name' Should -Exist"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-Item 'name' | Should -Exist"
        }
    }

    Context 'One Parameter with a space' {
        BeforeAll {
            $options = @{
                TestName       = 'MyTest'
                TestExpression = { Get-Item '$Target' }
                Target         = "Spaced Value"
                Should         = { Should -Exist }
            }

            $results = Get-PoshspecParam @options
        }
        It "Should return the correct test Name" {
            $results.Name | Should -Be "MyTest 'Spaced Value' Should -Exist"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-Item 'Spaced Value' | Should -Exist"
        }
    }

    Context 'Two Parameters' {
        BeforeAll {
            $options = @{
                TestName       = 'MyTest'
                TestExpression = { Get-Item '$Target' '$Property' }
                Target         = 'Name'
                Property       = 'Something'
                Should         = { Should -Exist }
            }

            $results = Get-PoshspecParam @options
        }
        It "Should return the correct test Name" {
            $results.Name | Should -Be "MyTest property 'Something' for 'Name' Should -Exist"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-Item 'name' 'Something' | Select-Object -ExpandProperty 'Something' | Should -Exist"
        }
    }

    Context 'Three Parameters' {
        BeforeAll {
            $options = @{
                TestName       = 'MyTest'
                TestExpression = { Get-Item '$Target' '$Property' '$Qualifier' }
                Target         = 'Name'
                Property       = 'Something'
                Qualifier      = 1
                Should         = { Should -Exist }
            }

            $results = Get-PoshspecParam @options

            It "Should return the correct test Name" {
                $results.Name | Should -Be "MyTest property 'Something' for 'Name' at '1' Should -Exist"
            }

            It "Should return the correct test Expression" {
                $results.Expression | Should -Be "Get-Item 'name' 'Something' '1' | Select-Object -ExpandProperty 'Something' | Should -Exist"
            }
        }
    }
}
