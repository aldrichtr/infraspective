
Describe 'Testing the UserRightsAssignment specification' -Tag @('unit', 'UserRightsAssignment', 'poshspec') {
    BeforeAll {
        Mock Test-RunAsAdmin -Module infraspective { return $true }
        Mock Invoke-PoshspecExpression -Module infraspective {
            return $InputObject
        }
    }
    Context 'UserRightsAssignment' {
        BeforeAll {
            $results = UserRightsAssignment ByRight 'SeNetworkLogonRight' {
                Should -Be @("BUILTIN\Users", "BUILTIN\Administrators")
            }
        }

        It "Should return the correct test Name" {
            $results.Name | Should -Be "UserRightsAssignment 'SeNetworkLogonRight' Should -Be @(`"BUILTIN\Users`", `"BUILTIN\Administrators`")"
        }

        It "Should return the correct test Expression" {
            $results.Expression | Should -Be "Get-AccountsWithUserRight -Right 'SeNetworkLogonRight' | Select-Object -ExpandProperty Account | Should -Be @(`"BUILTIN\Users`", `"BUILTIN\Administrators`")"
        }
    }

}
