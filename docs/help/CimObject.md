---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/CimObject.md
schema: 2.0.0
---

# CimObject

## SYNOPSIS
Test the value of a CimObject Property.

## SYNTAX

```
CimObject [-Target] <String> [-Property] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Test the value of a CimObject Property.
The Class can be provided with the Namespace.
See Example.

## EXAMPLES

### EXAMPLE 1
```
CimObject Win32_OperatingSystem SystemDirectory { Should -Be C:\WINDOWS\system32 }
```

### EXAMPLE 2
```
CimObject root/StandardCimv2/MSFT_NetOffloadGlobalSetting ReceiveSideScaling { Should -Be Enabled }
```

## PARAMETERS

### -Property
Specifies an instance property to retrieve.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
Specifies the name of the CIM class for which to retrieve the CIM instances.
Can be just the ClassName
in the default namespace or in the form of namespace/className to access other namespaces.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ClassName

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Assertions: Be, BeExactly, Match, MatchExactly

## RELATED LINKS
