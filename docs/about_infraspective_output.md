# Infraspective output types

## about_infraspective_output

# SHORT DESCRIPTION

Infraspective has three types of output that display progress and status of both the tests being
performed and the program and functions that run them.

# LONG DESCRIPTION

Like most command line programs and scripts, `infraspective` sends output

- ResultInfo objects on the pipeline
- Console status messages
- Logging messages

## The Pipeline

`infraspective` is a PowerShell module first, and the pipeline is PowerShell's superpower 💪.
Checklists, Groupings and Controls all have a ResultInfo object that is sent to the pipeline which
can then be used by other functions such as `ConvertTo-Json`, `Foreach-Object`, etc.

- [ ] I need to add either resultinfo information here or a link to another doc.

## Console status messages

- [ ] lookup references to the "Write-Host == bad" article
- [ ] include a short description of powershell's streams
- [ ] talk about the config



## Logging messages

- [ ] Introduce the Logging module
- [ ] talk about the targets and the config

# EXAMPLES
{{ Code or descriptive examples of how to leverage the functions described. }}

# NOTE
{{ Note Placeholder - Additional information that a user needs to know.}}

# TROUBLESHOOTING NOTE
{{ Troubleshooting Placeholder - Warns users of bugs}}

{{ Explains behavior that is likely to change with fixes }}

# SEE ALSO
{{ See also placeholder }}

{{ You can also list related articles, blogs, and video URLs. }}

# KEYWORDS
{{List alternate names or titles for this topic that readers might use.}}

- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}
