function Test-RunAsAdmin {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [CmdletBinding()]
    param()
    begin {
        Write-Debug "-- Begin $($MyInvocation.MyCommand.Name)"

    }
    process {
        ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    }
    end {
        Write-Debug "-- End $($MyInvocation.MyCommand.Name)"
    }
}
