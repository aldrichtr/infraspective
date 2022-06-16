

function Invoke-Infraspective {
    <#
    .SYNOPSIS
        Perform an audit on the specified hosts
    .DESCRIPTION
        Run checklists, groupings and controls in files specified in the configuration.
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
        [Parameter(
        )]
        [String[]]$Path,

        # Alternate configuration file
        [Parameter(
        )]
        [string]$Configuration
    )

    begin {
        try {
            $c = Import-Configuration
            $c.PSTypeName = 'Infraspective.Configuration'
            $config = [PSCustomObject]$c
        } catch {
            Write-Error "There was an error loading the configuration`n$_" -ErrorAction Stop
        }

        $audit_state = New-InfraspecAuditState
        $audit_state.Configuration = $config
        $audit_state.SessionState = $PSCmdlet.SessionState
        $targets = $config.Logging.Targets
        $log_option = @{
            Scope     = 'Audit'
            Level     = 'INFO'
            Message   = ''
            Arguments = ''
        }

        foreach ($target in $targets.Keys) {
            Add-LoggingTarget -Name $target -Configuration $targets[$target]
            Write-CustomLog @log_option -Message "Logging initialized on $target"
        }

        $TotalCount = 0
        $FailedCount = 0
        $PassedCount = 0
        $SkippedCount = 0

    }
    process {
        Write-CustomLog @log_option -Message 'Generating file list'

        $file_options = $config.Audit

        if ($PSBoundParameters['Path']) {
            $file_options.Path = $Path
        }

        Write-CustomLog @log_option -Level 'DEBUG' -Message @'
  - Path:    {0}
  - Filter:  {1}
  - Include: {2}
  - Exclude: {3}
  - Recurse: {4}
'@ -Arguments  @(
            $file_options.Path
            $file_options.Filter
            $file_options.Include
            $file_options.Exclude
            $file_options.Recurse
        )

        $audit_files = Get-ChildItem @file_options

        Write-CustomLog @log_option -Message "Found $($audit_files.Count) audit files"

        $audit_state.AuditTimer.Restart()

        Write-CustomLog @log_option -Message 'Audit start'
        Write-Result Audit 'Start' "Audit $(Get-Date -Format 'dd-MMM-yyyy HH:mm:ss')"

        foreach ($f in $audit_files) {
            if ($PSCmdlet.ShouldProcess($f, 'Perform tests')) {
                $audit_state.Depth += 1
                $audit_state.CurrentPath = $f.Directory.FullName

                Write-CustomLog @log_option -Message "File $($f.Name) start"

                Write-Result File 'Start' "File $($f.Name)"

                [scriptblock]$sb = { . $f.FullName }

                Write-CustomLog @log_option -Level 'DEBUG' -Message " Executing Audit file $($f.Name)"
                $result = & $sb
                $result.Container = $f
                $audit_state.Depth -= 1

                Write-CustomLog @log_option -Message "File $($f.Name) complete"

                $TotalCount += $result.TotalCount
                $PassedCount += $result.PassedCount
                $FailedCount += $result.FailedCount
                $SkippedCount += $result.SkippedCount

                Write-Output $result
            }
        }

    }
    end {
        $message = (
            'Audit complete.  Total files {0} executed in {1:N4} milliseconds' -f $audit_files.Count,
            $audit_state.AuditTimer.Elapsed.MilliSeconds)
        Write-Result Audit 'End' $message -Stats @{
            Total   = $TotalCount
            Passed  = $PassedCount
            Failed  = $FailedCount
            Skipped = $SkippedCount
        }
        Write-CustomLog @log_option -Message $message
    }
}
