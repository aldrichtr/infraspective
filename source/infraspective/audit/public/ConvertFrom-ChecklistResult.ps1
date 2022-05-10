
function ConvertFrom-ChecklistResult {
    <#
    .SYNOPSIS
        Convert an Infraspective.Checklist.ResultInfo to a readable output
    #>
    [CmdletBinding()]
    param(
        # The ResultInfo to convert
        [Parameter(
            ValueFromPipeline
        )]
        [PSTypeName('Infraspective.Checklist.ResultInfo')]$Result
    )
    begin {}
    process {

    }
    end {}
}
