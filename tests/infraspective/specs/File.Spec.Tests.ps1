
Describe 'Testing the File specification' -Tag @('unit', 'File', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -ModuleName infraspective {
            return $InputObject
        }
        $results = File C:\installAgent.log { Should -Exist }

    }
    Context 'File' {
        It "Should return the correct test Name" {
            $results.Name | Should -Be "File 'installAgent.log' Should -Exist"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "'C:\installAgent.log' | Should -Exist"
        }
    }
}
