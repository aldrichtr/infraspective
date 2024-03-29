---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-File.md
schema: 2.0.0
---

# Measure-File

## SYNOPSIS

Test a File.

## SYNTAX

```powershell
Measure-File [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test the Existence or Contents of a File

## EXAMPLES

### EXAMPLE 1: Test that a file exists

```powershell
File C:\inetpub\wwwroot\iisstart.htm { Should -Exist }
```

### EXAMPLE 2: Test that the file has given content

```powershell
File C:\inetpub\wwwroot\iisstart.htm { Should -Contain 'text-align:center' }
```

## PARAMETERS

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction,
-ErrorVariable, -InformationAction, -InformationVariable, -OutVariable,
-OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see
[about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Assertions: Exist and Contain

## RELATED LINKS
