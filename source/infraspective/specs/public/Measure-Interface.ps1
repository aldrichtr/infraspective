
function Measure-Interface {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('Interface')]
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
            Mandatory,
            Position = 2,
            ParameterSetName = "Default"
        )]
        [Parameter(
            ParameterSetName="Property",
            Position = 3,
            Mandatory
        )]
        [scriptblock]$Should
    )
   begin {
   }
   process {
       $expression = {Get-NetAdapter -Name '$Target' -ErrorAction SilentlyContinue}
       $params = Get-PoshspecParam -TestName Interface -TestExpression $expression @PSBoundParameters
   }
   end {
       Invoke-PoshspecExpression @params
   }


}
