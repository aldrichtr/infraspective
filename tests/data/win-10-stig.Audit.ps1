Checklist "Win10_STIG" -Title "Microsoft Windows 10 Security Technical Implementation Guide" -Version "2.3" {

    Control "SV-220697r569187_rule" -Resource "Windows" -Impact "medium" -Reference 'CCI:000366'-Title (
        "Domain-joined systems must use Windows 10 Enterprise Edition 64-bit version.") -Description (
        "Credential Guard use virtualization based security to protect...") {
        Describe "Verify domain-joined systems are the proper version" {
            Context "Given the current computer" {
                BeforeAll {
                    $v = Get-WindowsVersion
                }

                It "Should be Windows 10" {
                    $v.ProductName | Should -match '^Windows 10'
                }
                It "Should be Enterprise Edition" {
                    $v.EditionID | Should -match 'Enterprise'
                }
                It "Should be 64 bit" {
                    [Environment]::Is64BitOperatingSystem | Should -BeTrue
                }
            }
        }
    }

    Include "control_v-63321.ps1"
}
