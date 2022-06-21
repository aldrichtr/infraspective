
function Get-InfraspecConfiguration {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "-- Begin $($MyInvocation.MyCommand.Name)"
    }
    process {
        if($audit_state) {
        $config = $audit_state.Configuration
        Write-Host "getting state config"
    } else {
        $config = Import-Configuration
    }
        Write-Output $config
    }
    end {
        Write-Debug "-- End $($MyInvocation.MyCommand.Name)"
    }
}
