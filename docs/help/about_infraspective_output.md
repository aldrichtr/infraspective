# Infraspective Output

## about_InfraspectiveOutput

## SHORT DESCRIPTION

Infraspective has three types of output that display progress and status of both
the tests being performed and the program and functions that run them. Each
output type has it's own configuration, format and metadata. These output types
are:

- The PowerShell pipeline
- The console
- The Log

## LONG DESCRIPTION

Like most command line programs and scripts, `infraspective` sends output to the
console to indicate the current status of the program, the individual Elements
(`Checklists`, `Groupings`, `Controls`, etc.), and the result of tests. If you
are familiar with `Pester` already, then you know that there is both an Output
and a Result object.  `infraspective` divides output into three types:

- Pipeline: This is the `ResultInfo` objects on the pipeline
- Output: This is text based output on the commandline based on event types
- Logging: `infraspective` functional status messages, such as processes
  being started or stopped, environmental conditions, etc.

### The Pipeline

`infraspective` is a PowerShell module first, and the pipeline is PowerShell's
superpower 💪. `Checklists`, `Groupings` and `Controls` all have a `ResultInfo`
object that is sent to the pipeline which can then be used by other functions
such as `ConvertTo-Json`, `Foreach-Object`, `Format-Table` ... Anything you
would expect to do with a pipeline object.

See the help documentation for `Invoke-InfraspecChecklist`,
`Invoke-InfraspecControl`, etc for the specific object details for that Element.

### Console status messages

Objects on the pipeline can be sent be formatted using [special
xml](about_format.md) files, in order to generate the text you want to see on
the command line. However, those files are a bit complicated to use in practice.
So infraspective offers a text-based output system that is separate from the
pipeline. It has it's own custom template syntax and a rich set of porcelain
features including colors, html entities, emojis and nerd-font options.

  **NOTE:** Output is not stdout!!.

#### Output Streams

In PowerShell, there are 7 streams, and 6 of them support redirection.
`infraspective` uses the `Information Stream` (6) to write messages to the
screen. That makes it possible to pipe the result object while still getting
output on the screen, like:

```powershell
Invoke-Infraspective | ConvertTo-Json |
Invoke-RestMethod -Method POST -Uri $ws_uri -Headers $headers
```

```Output
+- {Audit} - Started at 2022 Jul 15 17:03 on MYPC by Domain\User
...
```

In this example, only the `ResultInfo` objects would get converted to json and
sent to the webservice, the `Output` would still show on the screen.

Or, If you'd like to see the objects on the screen, and stow the output in a
file, you could:

```powershell
# Information Stream == 6
Invoke-Infraspective 6> ".\latest_audit.txt"
```

> **_NOTE_**
>
> Internally, `infraspective` calls `Write-Information` not `Write-Host` even
> though `Write-Host` was fixed to send to the Information stream in version
> 5.0. That's because when the creator of PowerShell writes a blog
> [post](https://www.jsnover.com/blog/2013/12/07/write-host-considered-harmful/)
> about why you shouldn't use `Write-Host`, you probably shouldn't use it.

see
[about_infraspective_output_templates](about_infraspective_output_templates.md)
for details on controlling output

### Logging messages

`infraspective` uses the `Logging` module to handle functional messages about
session information, errors, warnings and significant actions.

#### Levels

There are four levels of logging, each level provides increasing verbosity:

- **ERROR** Events that have a negative impact on the functionality of the
  program.
- **WARNING** Events that may impact the results, but the program can continue
- **INFO** Events that provide information about the current state, environment
  or results of the program
- **DEBUG** Events that provide diagnostic information to aide in
  troubleshooting

#### Targets

The `Logging` module provides several `Targets` for log messages. These are
_where_ the log output is sent.  Currently, it supports the following Targets:

- Console
- File
- Windows Event Log
- Azure Log Analytics
- Elastic Search
- Email
- Slack
- Teams
- Webex Teams
- Seq Web Service

You can add additional targets if needed, see the module documentation for help
with how to configure them.

Targets are controlled by the `Logging` section of the configuration like this:

```powershell
## configuration.psd1
@{
    #...
    Logging = @{
        Targets = @{
            File = @{
                PrintBody = $false
                Append    = $true
                Encoding  = 'UTF-8'
                Level     = 'DEBUG'
                Format    = '[%{timestamp}] [%{level:7}] %{message}'
                # Path supports templating like $Logging.Format
                Path      = "${env:Temp}\infraspective-%{+%Y%m%d}.log"
            }
        }
    }
}
```

##### Format

The _Format_ property defines how the message is rendered.

The default value is: `[%{timestamp}] [%{level:-7}] %{message}`

The Log object has a number of attributes that are replaced in the format string
to produce the message:

| Format            | Description                                             |
|-------------------|---------------------------------------------------------|
| `%{timestamp}`    | Time when the log message was created. Defaults to      |
|                   | `%Y-%m-%d %T%Z` (_2016-04-20 14:22:45+02_). See note #1 |
| `%{timestamputc}` | UTC Time when the log message was created. Defaults to  |
|                   | `%Y-%m-%d %T%Z` (_2016-04-20 12:22:45+02_).             |
| `%{level}`        | Text logging level for the message (_DEBUG_, _INFO_,    |
|                   | _WARNING_, _ERROR_)                                     |
| `%{levelno}`      | Number logging level for the message (_10_, _20_,       |
|                   | _30_, _40_)                                             |
| `%{lineno}`       | The line number on which the write occurred             |
| `%{pathname}`     | The path of the caller                                  |
| `%{filename}`     | The file name part of the caller                        |
| `%{caller}`       | The caller function name                                |
| `%{message}`      | The logged message                                      |
| `%{body}`         | The logged body (json format not pretty printed)        |
| `%{execinfo}`     | The ErrorRecord catched in a try/catch statement        |
| `%{pid}`          | The process id of the currently running powershell      |
|                   | process ($PID)                                          |

- Note 1
  [Technet](https://technet.microsoft.com/en-us/library/hh849887.aspx)
  [Technet](https://msdn.microsoft.com/en-us/library/az4se3k1(v=vs.85).aspx)

  After the placeholder name you can pass a padding or a date format string
  separated by a colon (`:`):

**Note** A format string starting with a percent symbol (%) will use the
`UFormat` parameter of `Get-Date`

#### Components

`infraspective` logging Levels can be controlled independently. For example, if
you are troubleshooting a specific `Control` and you want to turn on diagnostic
messages, but you don't want to see _everything_, you can set the `Control`
Logging to `DEBUG` while leaving the other modules at `WARNING`. Those settings
are controlled by the `Logging` section of the configuration like this:

```powershell
## configuration.psd1
@{
    Logging = @{
        # ....
        Audit         = 'WARNING'
        Configuration = 'WARNING'
        Checklist     = 'WARNING'
        Control       = 'WARNING'
        Group         = 'WARNING'
        Include       = 'WARNING'
        Test          = 'WARNING'
        Result        = 'DEBUG'
    }
}
```

## TROUBLESHOOTING NOTE

- Logging Levels are controlled in two places:
  1. The `Level` key in the `Target`s configuration
  2. The individual Component's in the `Logging` configuration

  The `Target`'s  configuration is the _highest level_ at which it will display
  messages. If you want to see 'DEBUG' messages from a component, you need to
  1. Set the `Target`'s Level to 'DEBUG' _and_
  2. Set the Component(s) Level to 'DEBUG'

  This setup allows for the most flexibility on which log messages are sent to
  where.  You could potentially, troubleshoot a Control in a log file, while
  still only sending 'WARNING's and 'ERROR's to the Event Log.

- The `Format` syntax for `Logging` is different than for `Output`

## SEE ALSO

- [about_output_streams](about_output_streams.md)
- [about_redirection](about_redirection.md)
- [about_infraspective_configuration](about_infraspective_configuration.md)

## KEYWORDS

- Output
- Logging
- Results
