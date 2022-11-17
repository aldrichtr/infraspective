
Describe 'Testing the Folder specification' -Tag @('unit', 'Folder', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    
    Context 'Folder' {
        BeforeAll {
            $results = Folder $env:ProgramData { Should -Exist }
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "Folder 'C:\ProgramData' Should -Exist"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "'C:\ProgramData' | Should -Exist"
        }
    }

}
