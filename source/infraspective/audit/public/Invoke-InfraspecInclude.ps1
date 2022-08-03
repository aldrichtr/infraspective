

Set-Alias -Name Include -Value 'Invoke-InfraspecInclude' -Description 'Include the contents of a file'

function Invoke-InfraspecInclude {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [string[]]$Path,

        [Parameter(
        )]
        [string]$Filter,

        [Parameter(
        )]
        [string[]]$Include,

        [Parameter(
        )]
        [string[]]$Exclude,

        [Parameter(
        )]
        [switch]$FollowSymlink,

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
