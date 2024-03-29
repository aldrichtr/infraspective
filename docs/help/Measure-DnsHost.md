---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-DnsHost.md
schema: 2.0.0
---

# Measure-DnsHost

## SYNOPSIS

Test DNS resolution to a host.

## SYNTAX

```powershell
Measure-DnsHost [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test DNS resolution to a host.

## EXAMPLES

### EXAMPLE 1: A non-existent domain does not resolve

```powershell
DnsHost nonexistenthost.mymadeupdomain.tld { Should -Be $null }
```

### EXAMPLE 2: An existing domain is not null

```powershell
DnsHost www.google.com { Should -Not -Be $null }
```

## PARAMETERS

### -Target

The hostname to resolve in DNS.

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

Assertions: Be

## RELATED LINKS
