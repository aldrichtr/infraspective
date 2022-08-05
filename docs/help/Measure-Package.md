---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-Package.md
schema: 2.0.0
---

# Measure-Package

## SYNOPSIS

Test for installed package.

## SYNTAX

### Default (Default)

```powershell
Measure-Package [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

### Property

```powershell
Measure-Package [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test that a specified package is installed.

## EXAMPLES

### EXAMPLE 1: Test that a package is installed

```powershell
Package 'Microsoft Visual Studio Code' { should -Not -BeNullOrEmpty }
```

### EXAMPLE 2: Test that a specific version is installed

```powershell
Package 'Microsoft Visual Studio Code' version { should -Be '1.1.0' }
```

### EXAMPLE 3: Test that a package is not installed

```powershell
Package 'NonExistentPackage' { should -BeNullOrEmpty }
```

## PARAMETERS

### -Target

Specifies the Display Name of the package to search for.

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

Specifies an optional property to test for on the package.

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

Assertions: Be, BeNullOrEmpty

## RELATED LINKS
