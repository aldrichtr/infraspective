
function Get-InfraspecConfiguration {
    <#
    .SYNOPSIS
        Return the running configuration object
    .DESCRIPTION
        `Get-InfraspecConfiguration` returns the running configuration
    .EXAMPLE
        Get-InfraspecConfiguration
    #>
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "-- Begin $($MyInvocation.MyCommand.Name)"
    }
    process {
        if($audit_state) {
        $config = $audit_state.Configuration
    } else {
        $config = Import-Configuration
    }
        Write-Output $config
    }
    end {
        Write-Debug "-- End $($MyInvocation.MyCommand.Name)"
    }
}
