
@{
    Logging = @{
        <# -------------------------------------------------------------------------------------------------------------
    These settings control the Logging output.  infraspective uses the Logging module
    (https://github.com/EsOsO/Logging) which has several targets that logs can be sent to.

    From the Logging module documentation:
    --------------------------------------
    The Format property defines how the message is rendered.
    The default value is: [%{timestamp}] [%{level:-7}] %{message}
    The Log object has a number of attributes that are replaced in the format string to produce the message:
    |Format            |                                           Description                                 |
    |------------------|---------------------------------------------------------------------------------------|
    | %{timestamp}     | Time when the log message was created. Defaults to %Y-%m-%d %T%Z                      |
    |                  |     (2016-04-20 14:22:45+02) Take a look at                                           |
    |                  |     https://technet.microsoft.com/en-us/library/hh849887.aspx#sectionSection7 and     |
    |                  |     https://msdn.microsoft.com/en-us/library/az4se3k1(v=vs.85).aspx                   |
    | %{timestamputc}  | UTC Time when the log message was created. Defaults to %Y-%m-%d %T%Z                  |
    |                  |    (2016-04-20 12:22:45+02).                                                          |
    | %{level}         | Text logging level for the message (DEBUG, INFO, WARNING, ERROR)                      |
    | %{levelno}       | Number logging level for the message (10, 20, 30, 40)
    | %{lineno}        | The line number on wich the write occured
    | %{pathname}      | The path of the caller
    | %{filename}      | The file name part of the caller
    | %{caller}        | The caller function name
    | %{message}       | The logged message
    | %{body}          | The logged body (json format not pretty printed)
    | %{execinfo}      | The ErrorRecord catched in a try/catch statement
    | %{pid}           | The process id of the currently running powershellprocess ($PID)
    After the placeholder name you can pass a padding or a date format string separated by a colon (:):
    Note: A format string starting with a percent symbol (%) will use the UFormat parameter of Get-Date
    ------------------------------------------------------------------------------------------------------------- #>
        <#
    File = @{
        PrintBody = $false
        Append    = $true
        Encoding  = 'UTF-8'
        Level     = 'DEBUG'
        # Format    =
        # Path supports templating like $Logging.Format
        Path      = "${env:Temp}\infraspective-%{+%Y%m%d}.log"
    }
    #>
        Targets       = @{
            Console = @{
                Level        = 'DEBUG'
                Format       = '[%{timestamp}] %{level} %{caller}:%{lineno} - %{message}'
                #Format       = '[%{timestamp}] [%{level:7}] %{message}'
                ColorMapping = @{
                    'DEBUG'   = 'White'
                    'INFO'    = 'DarkBlue'
                    'WARNING' = 'Yellow'
                    'ERROR'   = 'Red'
                }
            }
        }

        Audit         = 'WARNING'
        Configuration = 'WARNING'
        Checklist     = 'WARNING'
        Control       = 'WARNING'
        Group         = 'WARNING'
        Include       = 'WARNING'
        Test          = 'WARNING'
        Result        = 'DEBUG'

    }

    Output  = @{
        <# -------------------------------------------------------------------------------------------------------------
    These options control status output to the screen.  Note that this output is on the 'Information' stream (6) in
    order to stay separate from the pipeline output.  If you want to redirect this output to a file, you can like
    this:
    Invoke-Infraspective 6> audit-results.log | select Result, Name
    ------------------------------------------------------------------------------------------------------------- #>
        <#
        The Scope controls which structures output status messages. Current options are:
        None, Audit, File, Checklist, Grouping, Control, Block or Test
        #>
        Scope     = 'Test'
        <#
        Control the format of the status message:
            Color = the [System.ConsoleColor] name (foreground)
            Format = the string to display
            Reset = resets the color after the status tag.
              - $true : The status tag will be the color given, the remaining text will be
                        the default output color
              - $false : The entire line will be the color of the status tag
              #>
        StatusMap = @{
            Leader  = '|  '
            Default = @{
                Foreground = 'DarkGrey'
                Background = 'Black'
                Render     = $true
                Reset      = $true
            }
            Control = @{
                Start = @{
                    Format = '+- {${fg:blue}<%= $Scope %>${fg:clear}} - Impact: <%= $Impact %><%= $Name %>: <%= $Title %>'
                }
                End   = @{
                    Format = @'
[${fg:2767c0}&sum;<%= $Total %> ${fg:8fbc8f}&uarr;<%= $Passed %> ${fg:b22222}&darr;<%= $Failed %>${fg:clear}] &#xfab2; - &#x231A; {${fg:blue}<%= $Scope %>${fg:clear}} - <%= $Name %>: <%= $Title %>
'@
                }
            }

            Audit = @{
                Start = @{
                    Format = '+- {${fg:blue}<%= $Scope %>${fg:clear}} - Started at <%= $Time %> on <%= $env:COMPUTERNAME %> by <%= "$env:USERDOMAIN\$env:USERNAME" %>'
                }
                End = @{
                    Format = @'
[${fg:2767c0}&sum;<%= $Total %> ${fg:8fbc8f}&uarr;<%= $Passed %> ${fg:b22222}&darr;<%= $Failed %>${fg:clear}] &#xfab2; -  {${fg:blue}<%= $Scope %>${fg:clear}} - <%= $Count %> files executed in &#x231A; <%= "{0:N4}" -f $Duration %> Milliseconds
'@
                }
            }
            Passed  = @{
                Format = '[${fg:green}<%= $Type %>${fg:clear}] - {${fg:blue}<%= $Scope %>${fg:clear}} - <%= $Name %>: <%= $Title %>'
            }
            Failed  = @{
                Format = '[${fg:red}<%= $Type %>${fg:clear}] - {${fg:blue}<%= $Scope %>${fg:clear}} - <%= $Name %>: <%= $Title %>'
            }
            Skipped = @{
                Format = '[${fg:darkgrey}<%= $Type %>${fg:clear}] - {${fg:blue}<%= $Scope %>${fg:clear}} - <%= $Name %>: <%= $Title %>'
            }
            Start   = @{
                Format = '+- {${fg:blue}<%= $Scope %>${fg:clear}} - <%= $Name %>: <%= $Title %>'
            }
            End     = @{
                Format = @'
[${fg:2767c0}&sum;<%= $Total %> ${fg:8fbc8f}&uarr;<%= $Passed %> ${fg:b22222}&darr;<%= $Failed %>${fg:clear}] &#xfab2; - &#x231A; {${fg:blue}<%= $Scope %>${fg:clear}} - <%= $Name %>: <%= $Title %>
'@
            }
        }
    }

    Audit   = @{
        <# -------------------------------------------------------------------------------------------------------------
        These options tell Invoke-Infraspective which files to run.
        ------------------------------------------------------------------------------------------------------------- #>

        Path    = '.\tests\data\*'
        Filter  = '*.Audit.ps1'
        Recurse = $false
        Include = $null
        Exclude = $null
    }
}
