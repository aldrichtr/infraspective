function Service {
    <#
    .SYNOPSIS
        Test a Service.
    .DESCRIPTION
        Test the Status of a given Service.
    .EXAMPLE
        Service w32time { Should -Be Running }
    .EXAMPLE
        Service bits { Should -Be Stopped }
    .NOTES
        Only validates the Status property. Assertions: Be
    #>
    [CmdletBinding(DefaultParameterSetName = 'prop')]
    param(
        # Specifies the service names of service.
        [Parameter(Mandatory, Position = 1)]
        [Alias("Name")]
        [string]$Target,

        # Specifies the Property of the Service to test.  Defaults to 'Status'
        [Parameter(Position = 2, ParameterSetName = 'prop')]
        [string]$Property = 'Status',

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position = 2, ParameterSetName = 'noprop')]
        [Parameter(Mandatory, Position = 3, ParameterSetName = 'prop')]
        [scriptblock]$Should
    )

    begin {
    }
    process {
        if (-not $PSBoundParameters.ContainsKey('Property')) {
            $Property = 'Status'
            $PSBoundParameters.Add('Property', $Property)
        }

        $params = Get-PoshspecParam -TestName Service -TestExpression {
            Get-Service -Name '$Target' } @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }

}
