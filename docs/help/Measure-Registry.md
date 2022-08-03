---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-Registry.md
schema: 2.0.0
---

# Measure-Registry

## SYNOPSIS

Test a Registry Key.

## SYNTAX

### Default (Default)

```powershell
Measure-Registry [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

### Property

```powershell
Measure-Registry [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test the Existence of a Key or the Value of a given Property.

## EXAMPLES

### EXAMPLE 1

```powershell
Registry HKLM:\SOFTWARE\Microsoft\Rpc\ClientProtocols { Should Exist }
```

### EXAMPLE 2

```powershell
Registry HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\ "NV Domain" { Should Be mybiz.local  }
```

### EXAMPLE 3

```powershell
Registry 'HKLM:\SOFTWARE\Callahan Auto\' { Should Not Exist }
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
