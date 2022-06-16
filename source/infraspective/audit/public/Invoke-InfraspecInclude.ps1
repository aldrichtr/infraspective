

Set-Alias -Name Include -Value 'Invoke-InfraspecInclude' -Description 'Include the contents of a file'

function Invoke-InfraspecInclude {
    <#
    .SYNOPSIS
        Include the contents of the given files.
    .DESCRIPTION
        Include the contents of the given file and execute the tests.
    #>
    [CmdletBinding()]
    param(
        # Specifies a path to one or more locations. Wildcards are accepted.
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [string[]]$Path,

        # Specifies a filter to qualify the Path parameter
        [Parameter(
        )]
        [string]$Filter,

        # Specifies an array of one or more string patterns to be matched as the cmdlet gets child items
        [Parameter(
        )]
        [string[]]$Include,

        # Specifies an array of one or more string patterns to be matched as the cmdlet gets child items
        [Parameter(
        )]
        [string[]]$Exclude,

        # Use the FollowSymlink parameter to search the directories that target those symbolic links
        [Parameter(
        )]
        [switch]$FollowSymlink,

        # Gets the items in the specified locations and in all child items of the locations
        [Parameter(
        )]
        [switch]$Recurse
    )
    begin {
        $log_option = @{
            Scope = 'Include'
            Level = 'INFO'
            Message = ''
            Arguments = ''
        }
    }
    process {
        $tmp_path = foreach ($p in $Path) {
            Join-Path -Path $audit_state.CurrentPath -ChildPath $p
        }
        Get-ChildItem -Path $tmp_path @PSBoundParameters | Foreach-Object {
            $file = Get-Item $_
            Write-CustomLog @log_option -Message "Including file : $($file.Name)"
            Write-CustomLog @log_option -Level DEBUG -Message "              : $($file.FullName)"
            & { . $file }
            Write-CustomLog @log_option -Level DEBUG -Message "Returned from calling included file"
        }
    }
    end {}
}
