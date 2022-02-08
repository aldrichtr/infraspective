Checklist "Security Audit" -Version "1.0.0" {

    Control "xccdf_blah" -Resource "Windows" -Impact 1 -Reference 'CVE:123' {
        Describe "cis control 123" {
            It "Should have foo set to bar" {
                $p.foo | Should -Be "bar"
            }
        }
    }
}
