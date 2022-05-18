

Set-Alias -Name Include -Value 'Invoke-InfraspecInclude' -Description 'Include the contents of a file'

function Invoke-InfraspecInclude {
    <#
    .SYNOPSIS
        Include the contents of the given file
    .DESCRIPTION
        Include the contents of the given file and execute the tests.
    #>
    [CmdletBinding()]
    param(
        # The file to include
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [string]$Path
    )
    begin {
        $file = ""
    }
    process {
        if (Test-Path $Path) {
            $file = $Path
        } elseif ( Test-Path (Join-Path $state.CurrentPath $Path)) {
            $file = Join-Path $state.CurrentPath $Path
        } else {
            throw "$Path could not be found"
        }
        Write-Log -Level INFO -Message "Including file : $file"
        & { . $file }
    }
    end {}
}
