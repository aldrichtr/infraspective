---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-Interface.md
schema: 2.0.0
---

# Measure-Interface

## SYNOPSIS
Test a local network interface.

## SYNTAX

### Default (Default)
```
Measure-Interface [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

### Property
```
Measure-Interface [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Test a local network interface and optionally and specific property.

## EXAMPLES

### EXAMPLE 1
```
interface ethernet0 { Should -Not -BeNullOrEmpty }
```

### EXAMPLE 2
```
interface ethernet0 status { Should -Be 'up' }
```

### EXAMPLE 3
```
Interface Ethernet0 linkspeed { Should -Be '1 gbps' }
```

### EXAMPLE 4
```
Interface Ethernet0 macaddress { Should -Be '00-0C-29-F2-69-DD' }
```

## PARAMETERS

### -Target
Specifies the name of the network adapter to search for.

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
Specifies an optional property to test for on the adapter.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Assertions: Be, BeNullOrEmpty

## RELATED LINKS
