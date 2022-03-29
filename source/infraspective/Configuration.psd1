<#
        NOTSET    ( 0)
        DEBUG     (10)
        INFO      (20)
        WARNING   (30)
        ERROR     (40)
#>


<#
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
#>

@{
    Logging   = @{
        File = @{
            PrintBody = $false
            Append    = $true
            Encoding  = 'UTF-8'
            Level     = 'DEBUG'
            # Format    =
            # Path supports templating like $Logging.Format
            Path      = "${env:Temp}\infraspective-%{+%Y%m%d}.log"
        }
        Console = @{
            Level = 'DEBUG'
#            Format = '[%{timestamp}] %{level} %{caller} - %{pathname}\%{filename}:%{lineno} - %{message}'
            Format = '[%{timestamp}] %{level} %{caller} - %{message}'
            ColorMapping = @{
                'DEBUG'   = 'White'
                'INFO'    = 'Gray'
                'WARNING' = 'Yellow'
                'ERROR'   = 'Red'
            }
        }
    }
    Checklist = @{
        Filter = "*.Audit.ps1"
    }
}
