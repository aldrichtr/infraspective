BeforeAll {
    . "$BuildRoot\source\infraspective\audit\public\Invoke-InfraspecChecklist.ps1"
}

$options = @{
    Name = "Testing the public function Invoke-InfraspecChecklist"
    Tag  = @('unit', 'Invoke', 'InfraspecChecklist')
}
Describe @options {
    Context "When the Discovery state is set to 'true'" {
        BeforeAll {
            #Mock Write-Log { return $null }
            $AuditState = @{
                Discovery     = $true
                Configuration = @{}
            }
            $child = @{
                Container = $null
            }

            $check = Invoke-InfraspecChecklist "Checklist test" { $child } -Title "A test checklist" -Version "0.1"
        }

        It "It should return an 'Infraspective.Checklist' object" {
            $check.PSObject.TypeNames[0] | Should -Be 'Infraspective.Checklist'
        }
        It "It should set the Name parameter" {
            $check.Name | Should -Be "Checklist test"
        }
        It "It should set the Title parameter" {
            $check.Title | Should -Be "A test checklist"
        }
        It "It should set the version to '0.1'" {
            $check.Version | Should -Be "0.1"
        }
    }
}
