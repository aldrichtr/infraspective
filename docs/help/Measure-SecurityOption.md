---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-SecurityOption.md
schema: 2.0.0
---

# Measure-SecurityOption

## SYNOPSIS

Test a Security Option.

## SYNTAX

```powershell
Measure-SecurityOption [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test the setting of a particular security option.

## EXAMPLES

### EXAMPLE 1

```powershell
SecurityOption 'Accounts: Administrator account status' { Should -Be Disabled }
```

### EXAMPLE 2

```powershell
SecurityOption 'Domain member: Maximum machine account password age' { Should -Be 30 }
```

### EXAMPLE 3

```powershell
SecurityOption 'Accounts: Block Microsoft accounts' { Should -Be $null }
```

## PARAMETERS

### -Target

Specifies the category of the security option.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Category

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

Assertions: Be, BeExactly, Match, MatchExactly

## RELATED LINKS
