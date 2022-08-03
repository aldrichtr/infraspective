---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-LocalUser.md
schema: 2.0.0
---

# Measure-LocalUser

## SYNOPSIS

Test if a local user exists and is enabled.

## SYNTAX

### Default (Default)

```powershell
Measure-LocalUser [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

### Property

```powershell
Measure-LocalUser [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test if a local user exists and is enabled.

## EXAMPLES

### EXAMPLE 1: Test if the account exists

```powershell
LocalUser 'Guest' { should -Not -BeNullOrEmpty }
```

### EXAMPLE 2: Test if the account is enabled

```powershell
LocalUser 'Guest' Disabled { should -Be $true }
```

## PARAMETERS

### -Target

The local user name to test for.
Eg 'Guest'

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

### -Property

The property of the account to test

```yaml
Type: String
Parameter Sets: Property
Aliases:

Required: False
Position: 3
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

Assertions: Be, BeExactly, BeNullOrEmpty, Match, MatchExactly

## RELATED LINKS
