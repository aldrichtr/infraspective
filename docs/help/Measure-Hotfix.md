---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-Hotfix.md
schema: 2.0.0
---

# Measure-Hotfix

## SYNOPSIS

Test if a Hotfix is installed

## SYNTAX

```powershell
Measure-Hotfix [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test if a Hotfix is installed

## EXAMPLES

### EXAMPLE 1: Test that a hotfix is installed

```powershell
Hotfix KB3116900 { Should -Not -BeNullOrEmpty}
```

### EXAMPLE 2: Test that a hotfix is absent

```powershell
Hotfix KB1112233 { Should -BeNullOrEmpty}
```

## PARAMETERS

### -Target

The Hotfix ID.
Eg KB1112233

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id

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
