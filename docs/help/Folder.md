---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Folder.md
schema: 2.0.0
---

# Folder

## SYNOPSIS
Test if a folder exists.

## SYNTAX

```
Folder [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Test if a folder exists.

## EXAMPLES

### EXAMPLE 1
```
folder $env:ProgramData { Should -Exist }
```

### EXAMPLE 2
```
folder C:\badfolder { Should -Not -Exist }
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
The path of the folder to search for.

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
Assertions: Exist

## RELATED LINKS
