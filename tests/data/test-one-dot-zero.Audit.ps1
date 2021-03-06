Checklist "Security Audit" -Version "1.0.0" -Title "Audit Windows servers against CIS controls" {

    Grouping "xccdf_controls" -Title "Controls mapped to the Win10 STIG Benchmark" {
        Grouping "registry_controls" -Title "Settings in the Windows Registry" {
            Control "xccdf_blah" -Resource "Windows" -Impact 1 -Reference 'CVE:123' {
                Describe "cis control 123" {
                    BeforeAll {
                        $p = @{
                            foo = "bar"
                        }
                    }
                    It "Should have foo set to bar" {
                        $p.foo | Should -Be "bar"
                    }
                }
            }
        }
        Grouping "file_controls" -Title "Directories, Files and Contents" {
            Control "xccdf_hostfile" -Resource "Windows" -Impact 1 -Reference 'CVE:123' {
                Describe "cis control 124" {
                    File "C:\windows\system32\drivers\etc\hosts" { Should -Exist }
                    File "C:\windows\system32\drivers\etc\hosts" { Should -FileContentMatch 'localhost' }
                }
            }
        }
    }
}
