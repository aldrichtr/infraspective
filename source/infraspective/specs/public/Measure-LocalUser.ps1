
function Measure-LocalUser {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('LocalUser')]
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        [Parameter(
            ParameterSetName = "Default",
            Position = 1,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = "Property",
            Position = 1,
            Mandatory
        )]
        [Alias('Name')]
        [string]$Target,

        [Parameter(
            ParameterSetName = "Property",
            Position = 2
        )]
        [string]$Property,

        [Parameter(
            ParameterSetName = "Default",
            Position = 2,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = "Property",
            Position = 3,
            Mandatory
            )]
        [scriptblock]$Should
    )
    begin {
    }
    process {
        $expression = { Get-CimInstance -ClassName Win32_UserAccount -filter "LocalAccount=True AND` Name='$Target'" }
        $params = Get-PoshspecParam -TestName LocalUser -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}
