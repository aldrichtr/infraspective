
function Measure-Interface {
    <#
    .SYNOPSIS
        Test a local network interface.
    .DESCRIPTION
        Test a local network interface and optionally and specific property.
    .EXAMPLE
        interface ethernet0 { Should -Not -BeNullOrEmpty }
    .EXAMPLE
        interface ethernet0 status { Should -Be 'up' }
    .EXAMPLE
        Interface Ethernet0 linkspeed { Should -Be '1 gbps' }
    .EXAMPLE
        Interface Ethernet0 macaddress { Should -Be '00-0C-29-F2-69-DD' }
    .NOTES
        Assertions: Be, BeNullOrEmpty
    #>
    [Alias('Interface')]
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
        # Specifies the name of the network adapter to search for.
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Default")]
        [Parameter(Mandatory, Position=1,ParameterSetName="Property")]
        [Alias('Name')]
        [string]$Target,

        # Specifies an optional property to test for on the adapter.
        [Parameter(Position=2,ParameterSetName="Property")]
        [string]$Property,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position=2,ParameterSetName="Default")]
        [Parameter(Mandatory, Position=3,ParameterSetName="Property")]
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
