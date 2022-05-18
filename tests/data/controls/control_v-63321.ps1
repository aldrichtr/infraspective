

Control "SV-220856r569187_rule" -Resource "Windows" -Impact "medium" -Reference 'CCI:001812'-Title (
    "Users must be prevented from changing installation options.") -Description (
    "Installation options for applications are typically controlled by administrators...") {
    Describe "Verify users cannot change installation options" {
        Registry 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer\' 'EnableUserControl' { Should -Be 0 }
    }
}
