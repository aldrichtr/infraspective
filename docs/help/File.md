---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/File.md
schema: 2.0.0
---

# File

## SYNOPSIS
Test a File.

## SYNTAX

```
File [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Test the Existance or Contents of a File..

## EXAMPLES

### EXAMPLE 1
```
File C:\inetpub\wwwroot\iisstart.htm { Should Exist }
```

### EXAMPLE 2
```
File C:\inetpub\wwwroot\iisstart.htm { Should Contain 'text-align:center' }
```

## PARAMETERS

### -Should
A Script Block defining a Pester Assertion.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
Specifies the path to an item.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Path

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Assertions: Exist and Contain

## RELATED LINKS
