---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-SoftwareProduct.md
schema: 2.0.0
---

# Measure-SoftwareProduct

## SYNOPSIS

Test the installed Software Packages.

## SYNTAX

### Default (Default)

```powershell
Measure-SoftwareProduct [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

### Property

```powershell
Measure-SoftwareProduct [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test the Existence of a Software Package or the Value of a given Property.

## EXAMPLES

### EXAMPLE 1

```powershell
SoftwareProduct 'Microsoft .NET Framework 4.6.1' { Should -Exist }
```

### EXAMPLE 2

```powershell
SoftwareProduct 'Microsoft SQL Server 2016' DisplayVersion { Should -Be 13.0.1100.286  }
```

### EXAMPLE 3

```powershell
SoftwareProduct 'IIS 10.0 Express' InstallLocation { Should -Match 'C:\Program Files (x86)' }
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

### -Property

Specifies a property at the specified Path.

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

Assertions: Be, BeExactly, Exist, Match, MatchExactly

## RELATED LINKS
