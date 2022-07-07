---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Write-Result.md
schema: 2.0.0
---

# Write-Result

## SYNOPSIS
Write the results to the screen

## SYNTAX

```
Write-Result [-Scope] <ResultScope> [-Type] <String> [-Data <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
\`Write-Result\` sends formatted output to the Information stream (6). 
The format
of the output is controlled by the 'Output' key in the Configuration settings.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Scope
Scope of result. 
'File', 'Checklist', etc.
See also: about_infraspective_output

```yaml
Type: ResultScope
Parameter Sets: (All)
Aliases:
Accepted values: None, Audit, File, Checklist, Grouping, Control, Block, Test

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Type of Event.
'Start', 'End', 'Pass', 'Fail', 'Skip', etc.
See also: about_infraspective_configuration

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
Each Element passes their Parameters, Statistics and other Metadata in a HashTable
so that it can be used in the Output template. 
For example:
Data.Impact = 1 would be available as \<%= $Impact %\>

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
