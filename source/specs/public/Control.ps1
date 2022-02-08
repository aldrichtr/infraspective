
Function Control {
    <#
    .SYNOPSIS
        A security control
    #>
    [CmdletBinding()]
    param(
        # The unique ID for this control
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name,

        # The criticality, if this control fails
        [Parameter(
            ValueFromPipeline
        )]
        [double]$Impact,

        # The human readable title
        [Parameter()]
        [string]$Title,

        # An optional description of the test
        [Parameter()]
        [string[]]$Description,

        # The tests associated with this control
        [Parameter(Position = 1)]
        [ValidateNotNull()]
        [scriptblock]$Test
    )
    begin {
        $block = [ScriptBlock]::Create(
            "{ Describe `"$Name`" {`n $Test`n}`n}"
            )
    }
    process {
        $container = New-PesterContainer -ScriptBlock $Test
        Invoke-Pester -Container $container
    }
    end {}
}
