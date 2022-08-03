---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-AppPool.md
schema: 2.0.0
---

# Measure-AppPool

## SYNOPSIS

Test an IIS Application Pool

## SYNTAX

### Default (Default)

```powershell
Measure-AppPool [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

### Property

```powershell
Measure-AppPool [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

`Measure-AppPool` will test IIS Application Pool status and validate various
properties. Nested properties are supported and can be accessed by using a '.'
as the separator such as `property.subproperty`.

`Measure-AppPool` is aliased as `AppPool`

## EXAMPLES

### EXAMPLE 1: Test the status of the AppPool

```powershell
Measure-AppPool 'TestSite' { Should -Be Started }
```

### EXAMPLE 2: Test a property of the AppPool

```powershell
Measure-AppPool 'TestSite' 'ManagedPipelineMode' { Should -Be 'Integrated' }
```

### EXAMPLE 3: Test a nested property of the AppPool

```powershell
Measure-AppPool 'TestSite' 'ProcessModel.IdentityType' { Should -Be 'ApplicationPoolIdentity'}
```

## PARAMETERS

### -Target

The name of the App Pool to be Tested

```yaml
Type: String
Parameter Sets: (All)
Aliases: Path

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property

The Property to be expanded. If omitted, property will default to status.
Can handle nested objects within properties

```yaml
Type: String
Parameter Sets: Property
Aliases:

Required: False
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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [System.String]

## OUTPUTS

### System.String

## NOTES

Assertions: -Be
## RELATED LINKS
