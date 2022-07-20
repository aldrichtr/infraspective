# infraspective_output_templates

## about_infraspectiveOutputTemplates

## SHORT DESCRIPTION

`infraspective` provides a rich template system for writing output to the
screen. The output is controlled by the `Format` key in the `Output` section of
the configuration. It supports colors, html entities, emojis and nerd-font
glyphs.

## LONG DESCRIPTION

Each `infraspective` Element has five event types;

- **Start** At the beginning of the element body, but prior to processing any
  content
- **End** At the end of the element body, after all sub-elements have
  completed
- **Passed** When an element's status is set to `Passed`
- **Failed** When an element's status is set to `Failed`
- **Skipped** When an element's status is set to `Skipped`

When an element event occurs, `infraspective` checks the `Output` section of the
configuration, and outputs the status of the event based on the settings.

The Output section of the configuration has two main sections:

- **Scope** Controls which elements send output to the console
- **StatusMap** Controls the format of the status messages


### Scope

Currently, there are nine options for the `Scope` Setting

- **None** No information is sent to Output.
- **Audit** the `infraspective` audit start and the final status, with totals
- **File** Each file specified in the `Audit` section of the Configuration
- **Checklist** Each `Checklist` including the final status and totals
- **Grouping** Each `Grouping` including the final status and totals
- **Control** Each `Control` including the final status and totals
- **Block** Each `Pester` block, such as `Describe` and `Context`
- **Test** Each individual `Pester` Test.


### StatusMap

There are several components of the status output that can be configured:

- **Leader** A set of characters used as "indentation markers"
- **Default** Set the formatting defaults for all status Event Types
- **Passed** , **Failed**, **Skipped** Set the formatting details for a
  specific result
- **Start**, **End** Set the formatting details for elements as they begin and
  end

Additionally, if you want to set unique format settings per `Scope`, you can add
those to `StatusMap`, and then add the event types you want to configure in that
key.

Any value that is not explicitly set will use the `Default` setting

Each event type can have the following keys:

- **Foreground** The color of the text
- **Background** The color behind the text
- **Render** Whether or not to render symbols in the template
- **Reset** Whether or not to reset the colors at the end of the line of text
- **Format** A template used for formatting the information sent to the
  console

## Format

The template system uses two modules. First,
[EPS](https://github.com/straightdave/eps) provides a simple but powerful
template language similar to ERB. Second is
[Pansies](https://github.com/PoshCode/Pansies) which provides a rich set of
colors and symbols. At runtime, `infraspective` uses the Text in the `Format`
field to transform the Output with the template system, and decorate the output
with the colors and entities.

### Tokens

A token looks like this: `<% token_body %>`, and the token body can be
PowerShell code, expressions or comments.  From the module's documentation:

> EPS allows PowerShell code to be embedded within a pair of `<% ... %>`,
> `<%= ... %>`, or `<%# ... %>` as well:
>
> - Code in `<% CODE %>` blocks are executed but no value is inserted.
>   - If started with `<%-` : the preceding indentation is trimmed.
>   - If terminated with `-%>` : the following line break is trimmed.
> - Code in `<%= EXPRESSION %>` blocks insert the value of `EXPRESSION`.
>   - If terminated with `-%>` : the following line break is trimmed.
> - Text in `<%# ... %>` blocks are treated as comments and are removed from the
>   output.
>   - If terminated with `-%>` : the following line break is trimmed.
> - `<%%` and `%%>` : are replaced respectively by `<%` and `%>` in the output.
>
> All blocks accept multi-line content as long as it is valid PowerShell.

### Colors 🌈

If your console supports ANSI escape codes, the Foreground and Background of
text can be set using RGB codes, Console Colors, X11 Color Names or XTerm
indexes.

Each Output EventType ('Start', 'Passed', etc.) is set using the `Foreground`
and `Background` keys.

```powershell
## configuration.psd1
@{
    #...
    Output = @{
        StatusMap = @{
            #...
            Control = @{
                Start = @{
                    Foreground = 'DarkGray'
                    Background = 'Black'
                }
            }
        }
    }
}
```

When setting the Foreground or Background, you can use:

ConsoleColor names like `DarkRed`, or `Blue`

RGB Codes like `#00FF00` ,  or `00FF00`

xterm indexes like `xt123` or `123`

or X11 Color Names like: `AntiqueWhite4` or `DarkSlateGray`

Additionally, to change the color of certain text within the `Format` field, use
`fg:` for the foreground or `bg:` for the background like this:

`This is the start of the ${fg:DarkRed}Control${fg:clear} output`


### HTML Entities, Emojis and Nerd-Font Glyphs

Within your templates, you can add symbols (an entity, emoji or glyph) to help
visually distinguish Events. Symbols are denoted by a `&` then an
`<identifier>` , followed by a `;`

The identifier can be:

- An HTML entity name
- A '#' followed by a decimal character code
- A '#x' followed by a hex character code

Some examples:

| HTML Entity | &nbsp;   | Emoji       | &nbsp;    | Nerd-font glyphs | &nbsp; |
| ----------- | -------- | ----------- | --------- | ---------------- | ------ |
| Code        | Output   | Code        | Output    | Code             | Output |
| `&hearts;`  | &hearts; | `&#x231A;`  | &#x231A;  | `&#x23fb`        | ⏻      |
| `&copy;`    | &copy;   | `&#128540;` | &#128540; | `&#x23fb`        | ⏻      |
| `&#926;`    | &#926;   | `&#x1F61C;` | &#x1F61C; | `&#x23fb`        | ⏻      |

## SEE ALSO

- [about_infraspective_output](about_infraspective_output.md)
- [about_infraspective_configuration](about_infraspective_configuration.md)
