
function Write-Result {
    <#
    .SYNOPSIS
        Write the results to the screen
    .DESCRIPTION
        `Write-Result` sends formatted output to the Information stream (6).  The format
        of the output is controlled by the 'Output' key in the Configuration settings.

        - Scope: controls which structures output status messages. Current options are:
            None, Audit, File, Checklist, Grouping, Control, Block or Test
        - StatusMap:  A hashtable of Status Messages, and Scope Start and End hashtables.
          Each key can have:
          - Color: The $PSStyle color option to format the text
          - Format: The text to be displayed.  (The 'End' status is special, see below)
          - Reset: $true or $false.  If $false, the entire line will be the color set.

        - Leader: a text string to use as the indentation of each scope

        End Format:  Because the End of the scope can contain totals, the following tokens
            are available:
            '%T' : The Total tests for that scope
            '%P' : The Total amount of tests that 'Passed'
            '%F' : The Total amount of tests that 'Failed'
            '%S' : The Total amount of tests that 'Skipped'
    .LINK
        - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_ansi_terminals?view=powershell-7.2

        #>
    [CmdletBinding()]
    param(
        # Scope of result.  'File', 'Checklist', etc.
        # See also: about_infraspective_output
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [ResultScope]$Scope,

        # Type of result.  'Pass', 'Fail', 'Skip', etc.
        # See also: about_infraspective_configuration
        [Parameter(
            Mandatory,
            Position = 1
        )]
        [string]$Type,

        # The message to write
        [Parameter(
            Mandatory,
            Position = 2
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        # optionally provide statistics in a hashtable where the keys are:
        # Total, Passed, Failed, and Skipped and their values are a number
        [Parameter()]
        [hashtable]$Stats

    )
    begin {
        $config = $audit_state.Configuration.Output
        $map = $config.StatusMap
        $reset = $PSStyle.Reset

        $stat_tokens = @{
            '%T' = 'Total'
            '%P' = 'Passed'
            '%F' = 'Failed'
            '%S' = 'Skipped'
        }
        # state is initialized in `Invoke-Infraspective`
        $indent = ($config.Leader * $audit_state.Depth)
        $max_scope = ([ResultScope]$config.Scope).value__
    }
    process {
        # check to see if the requested Scope is higher than the configured scope
        # break early if it isnt
        $this_scope = $Scope.value__
        if ($this_scope -le $max_scope) {
            if (-not($map.Keys -contains $Type)) {
                $fmt = "$reset$Type"
            } else {
                $color = $map.$Type.Color
                if ([system.enum]::GetNames([System.ConsoleColor]) -contains $color) {

                    if ($Type -like 'End') {
                        # treat the end "cookie special"
                        $pre_fmt = "$($PSStyle.Foreground.$color)[$reset"
                        $pst_fmt = "$($PSStyle.Foreground.$color)]$reset"
                        $s_fmt = $map.End.Format
                        foreach ($token in $stat_tokens.Keys) {
                            # this looks scary, but what it's doing is:
                            # for each of the statistics tokens like '%P' in the
                            # Format for 'End', replace it with the value in the
                            # Stats hash corresponding to the value in the
                            # stats_token
                            # if Stats looks like @{Passed = 1; Total = 3}
                            # and the Format is '%P of %T' then the result should be
                            # 1 of 3
                            if ($s_fmt -match [regex]::Escape($token)) {
                                $token_status = $stat_tokens[$token]
                                if ($token_status -like 'Total') {
                                    $tok_color = $map.End.Color
                                } else {
                                    $tok_color = $map.$token_status.Color
                                }

                                $s_value = "$($PSStyle.Foreground.$tok_color)$($Stats[$stat_tokens[$token]])$reset"
                                $s_fmt = $s_fmt -replace [regex]::Escape($token), $s_value
                            }
                        }
                        $fmt = "$pre_fmt$s_fmt$pst_fmt"
                    } else {
                        $fmt = "$($PSStyle.Foreground.$color)$($map.$Type.Format)"
                    }
                    if ($map.$Type.Reset) {
                        $fmt += $reset
                    }
                } else {
                    $fmt = "$reset$($map.$Type.Format)"
                }
            }

            $output = "$indent$fmt $Message$reset"
            Write-Information $output -InformationAction Continue
        }
    }
    end {}
}
