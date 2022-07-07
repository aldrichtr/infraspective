---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/AppPool.md
schema: 2.0.0
---

# AppPool

## SYNOPSIS
Test an Application Pool

## SYNTAX

### Default (Default)
```
AppPool [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

### Property
```
AppPool [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Used To Determine if Application Pool is Running and Validate Various Properties

## EXAMPLES

### EXAMPLE 1
```
AppPool TestSite { Should -Be Started }
```

### EXAMPLE 2
```
AppPool TestSite ManagedPipelineMode { Should -Be 'Integrated' }
```

### EXAMPLE 3
```
AppPool TestSite ProcessModel.IdentityType { Should -Be 'ApplicationPoolIdentity'}
```

## PARAMETERS

### -Property
The Property to be expanded.
If Ommitted, Property Will Default to Status.
Can handle nested objects within properties

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

### -Target
The name of the App Pool to be Tested

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Assertions: Be

## RELATED LINKS
