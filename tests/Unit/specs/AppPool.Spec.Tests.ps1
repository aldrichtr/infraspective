
Describe 'Testing the AppPool specification' -Tag @('unit', 'AppPool', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    Context 'AppPool' {
        BeforeAll {
            $results = AppPool TestSite { Should -Be 'Started' }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "AppPool property 'State' for 'TestSite' Should -Be 'Started'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-IISAppPool -Name 'TestSite' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'State' | Should -Be 'Started'"
        }
    }

    Context 'AppPool with non-default Property' {
        BeforeAll {
            $results = AppPool TestSite ManagedPipelineMode { Should -Be 'Integrated' }
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "AppPool property 'ManagedPipelineMode' for 'TestSite' Should -Be 'Integrated'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-IISAppPool -Name 'TestSite' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'ManagedPipelineMode' | Should -Be 'Integrated'"
        }
    }

    Context 'AppPool with nested Property' {
        BeforeAll {
            $results = AppPool TestSite ProcessModel.IdentityType { Should -Be 'ApplicationPoolIdentity' }
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "AppPool property 'IdentityType' for 'TestSite' at 'ProcessModel' Should -Be 'ApplicationPoolIdentity'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "(Get-IISAppPool -Name 'TestSite' -ErrorAction SilentlyContinue).ProcessModel.IdentityType | Should -Be 'ApplicationPoolIdentity'"
        }
    }

    Context 'AppPool with Method Invocation' {
        BeforeAll {
            $results = AppPool TestSite 'ToString()' { Should -Be 'Microsoft.Web.Administration.ApplicationPool' }
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "AppPool property 'ToString()' for 'TestSite' Should -Be 'Microsoft.Web.Administration.ApplicationPool'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "(Get-IISAppPool -Name 'TestSite' -ErrorAction SilentlyContinue).ToString() | Should -Be 'Microsoft.Web.Administration.ApplicationPool'"
        }
    }

}
