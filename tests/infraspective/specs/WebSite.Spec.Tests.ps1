
Describe 'Testing the DnsHost specification' -Tag @('unit', 'DnsHost', 'poshspec') {
    BeforeAll {
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    Context 'WebSite' {
        BeforeAll {
            $results = WebSite TestSite { Should -Be 'Started' }
        }
        It "Should return the correct test Name" {
            $results.Name | Should -Be "WebSite property 'State' for 'TestSite' Should -Be 'Started'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-IISSite -Name 'TestSite' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'State' | Should -Be 'Started'"
        }
    }

    Context 'WebSite with non-default Property' {
        BeforeAll {
            $results = WebSite TestSite ManagedPipelineMode { Should -Be 'Integrated' }
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "WebSite property 'ManagedPipelineMode' for 'TestSite' Should -Be 'Integrated'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-IISSite -Name 'TestSite' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'ManagedPipelineMode' | Should -Be 'Integrated'"
        }
    }

    Context 'WebSite with nested Property' {
        BeforeAll {
            $results = WebSite TestSite 'Applications["/"].Path' { Should -Be '/' }
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "WebSite property 'Path' for 'TestSite' at 'Applications[`"/`"]' Should -Be '/'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "(Get-IISSite -Name 'TestSite' -ErrorAction SilentlyContinue).Applications[`"/`"].Path | Should -Be '/'"
        }
    }

    Context 'WebSite with Method Invocation' {
        BeforeAll {
            $results = WebSite TestSite 'Bindings.Count' { Should -Be '1' }
        }
        
        It "Should return the correct test Name" {
            $results.Name | Should -Be "WebSite property 'Count' for 'TestSite' at 'Bindings' Should -Be '1'"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "(Get-IISSite -Name 'TestSite' -ErrorAction SilentlyContinue).Bindings.Count | Should -Be '1'"
        }
    }
}
