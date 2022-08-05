---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-Share.md
schema: 2.0.0
---

# Measure-Share

## SYNOPSIS

Test if a share exists.

## SYNTAX

```powershell
Measure-Share [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test if a share exists.

## EXAMPLES

### EXAMPLE 1

```powershell
Share 'MyShare' { should -Not -BeNullOrEmpty }
```

### EXAMPLE 2

```powershell
Share 'BadShare' { should -BeNullOrEmpty }
```

## PARAMETERS

### -Target

The share name to test for.
Eg 'C$' or 'MyShare'

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

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

Assertions: BeNullOrEmpty

## RELATED LINKS
