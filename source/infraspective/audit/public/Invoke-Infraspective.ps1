

function Invoke-Infraspective {
    <#
    .EXTERNALHELP infraspective-help.xml
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
        <#------------------------------------------------------------------
          1.  Configuration
        ------------------------------------------------------------------#>
        $audit_paths  = @()
        $audit_files  = @()
        try {
            $config = Import-Configuration
        } catch {
            Write-Error "There was an error loading the configuration`n$_" -ErrorAction Stop
        }

        if ($config.keys -contains 'Audit') {
            $audit_paths += $config.Audit
        }
        $config.Remove('Audit')

        <#------------------------------------------------------------------
          2.  State information
        ------------------------------------------------------------------#>
        $audit_state = New-InfraspecAuditState
        $audit_state.Configuration = $config
        $audit_state.SessionState = $PSCmdlet.SessionState

        <#------------------------------------------------------------------
        3.  Initialize Logging
        ------------------------------------------------------------------#>
        $log_option = @{
            Scope     = 'Audit'
            Level     = 'INFO'
            Message   = ''
            Arguments = ''
        }
        $targets = $config.Logging.Targets
        foreach ($target in $targets.Keys) {
            Add-LoggingTarget -Name $target -Configuration $targets[$target]
            Write-CustomLog @log_option -Message "Logging initialized on $target"
        }

        <#------------------------------------------------------------------
          4.  Initialize counters
        ------------------------------------------------------------------#>
        $TotalCount   = 0
        $FailedCount  = 0
        $PassedCount  = 0
        $SkippedCount = 0

    }
    process {
        <#------------------------------------------------------------------
          5.  Update configuration
        ------------------------------------------------------------------#>
        if ($PSBoundParameters['Configuration']) {
            if (Test-Path $Configuration) {
                try {
                    $conf_item = Get-Item $Configuration
                    $base_path = $conf_item.Directory
                    $update = Import-Metadata $Configuration
                    if ($update.keys -contains 'Include') {
                        foreach ($c in $update.Include) {
                            $conf_path = Join-Path $base_path $c
                            if (Test-Path $conf_path) {
                                $sub_conf = Import-Metadata $conf_path
                                if (sub_conf.keys -contains 'Audit') {
                                    $audit_paths += $sub_conf.Audit
                                    $sub_conf.Remove('Audit')
                                    $audit_state.Configuration | Update-Object $sub_conf
                                }
                            } else {
                                Write-CustomLog @log_option -Level 'ERROR' "Could not import $conf_path"
                            }
                        }
                        $update.Remove('Include')
                    }
                    if ($update.keys -contains 'Audit') {
                        $audit_paths += $update.Audit
                    }
                    $update.Remove('Audit')

                    # TODO: Make a note that any configuration in the upper config overwrites any included config
                    $audit_state.Configuration | Update-Object $update
                } catch {
                    Write-CustomLog @log_option -Level 'ERROR' "Could not import $Configuration : $_"
                }
            }
        }

        <#------------------------------------------------------------------
          6.  Audit Files
        ------------------------------------------------------------------#>
        Write-CustomLog @log_option -Message 'Generating file list'
        foreach ($file_options in $audit_paths) {
            Write-CustomLog @log_option -Level 'DEBUG' -Message @'
  - Path:    {0}
  - Filter:  {1}
  - Include: {2}
  - Exclude: {3}
  - Recurse: {4}
'@ -Arguments @(
                $file_options.Path
                $file_options.Filter
                $file_options.Include
                $file_options.Exclude
                $file_options.Recurse
            )

            $audit_files += Get-ChildItem @file_options
        }
        Write-CustomLog @log_option -Message "Found $($audit_files.Count) audit files"

        $audit_state.AuditTimer.Restart()

        Write-CustomLog @log_option -Message 'Audit start'
        Write-Result Audit 'Start' -Data @{Time = Get-Date -format 'yyyy MMM dd HH:mm'}

        foreach ($f in $audit_files) {
            if ($PSCmdlet.ShouldProcess($f.Name, 'Audit')) {
                $audit_state.Depth += 1
                $audit_state.CurrentPath = $f.Directory.FullName

                Write-CustomLog @log_option -Message "File $($f.Name) start"
                Write-Result File 'Start' -Data @{ Name = $f.Name }

                [scriptblock]$sb = { . $f.FullName }

                Write-CustomLog @log_option -Level 'DEBUG' -Message " Executing Audit file $($f.Name)"
                $result = & $sb
                $result.Container = $f
                $audit_state.Depth -= 1

                Write-CustomLog @log_option -Message "File $($f.Name) complete"

                $TotalCount   += $result.TotalCount
                $PassedCount  += $result.PassedCount
                $FailedCount  += $result.FailedCount
                $SkippedCount += $result.SkippedCount

                Write-Output $result
            }
        }
    }
    end {
        Write-Result Audit 'End' -Data @{
            Count    = $audit_files.Count
            Duration = $audit_state.AuditTimer.Elapsed.MilliSeconds
            Total    = $TotalCount
            Passed   = $PassedCount
            Failed   = $FailedCount
            Skipped  = $SkippedCount
        }

        $message = (
            'Audit complete.  Total files {0} executed in {1:N4} milliseconds' -f $audit_files.Count,
            $audit_state.AuditTimer.Elapsed.MilliSeconds)

        Write-CustomLog @log_option -Message $message
    }
}
