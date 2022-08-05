
function Invoke-PoshspecExpression {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [PSCustomObject]$InputObject
    )
    begin {
        Write-Debug "-- Begin $($MyInvocation.MyCommand.Name)"
        $log_option = @{
            Scope = 'Test'
            Level = 'INFO'
            Message = ''
            Arguments = ''
        }
    }
    process {
        Write-CustomLog @log_option -Level 'DEBUG' -Message "Invoking 'it' block with expression: $($InputObject.Expression)"
        It $InputObject.Name -TestCases @(
            @{command = $InputObject.Expression }
        ) {
            & $command
        }
    }
    end {
        Write-Debug "-- End $($MyInvocation.MyCommand.Name)"
    }
}
