---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-Service.md
schema: 2.0.0
---

# Measure-Service

## SYNOPSIS

Test a Service.

## SYNTAX

### Default

```powershell
Measure-Service [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

### NoProperty

```powershell
Measure-Service [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test the Status of a given Service.

## EXAMPLES

### EXAMPLE 1

```powershell
Service w32time { Should -Be Running }
```

### EXAMPLE 2

```powershell
Service bits { Should -Be Stopped }
```

## PARAMETERS

### -Target

Specifies the service names of service.

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

Specifies the Property of the Service to test.
Defaults to 'Status'

```yaml
Type: String
Parameter Sets: prop
Aliases:

Required: False
Position: 3
Default value: Status
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
Position: 4
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

Only validates the Status property.
Assertions: Be

## RELATED LINKS
