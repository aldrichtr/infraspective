---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-AppPool.md
schema: 2.0.0
---

# Measure-AppPool

## SYNOPSIS
Test an Application Pool

## SYNTAX

### Default (Default)
```
Measure-AppPool [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

### Property
```
Measure-AppPool [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
\`AppPool\` will test IIS Application Pool status and validate various properties. 
Nested properties are
supported and can be accessed by using a '.' as the separator such as \`property.subproperty\`

## EXAMPLES

### EXAMPLE 1
```
AppPool TestSite { Should -Be Started } | Foreach-Object {
    "Hello second line of code"
}
```

\`\`\`Output
true
\`\`\`

Title: Test the status of the AppPool

This is additional text about example number 1

But this is even more text about example number 1, and there should be a blank line before
it, but not in the middle here

### EXAMPLE 2
```
Test a property of the AppPool
```

AppPool TestSite ManagedPipelineMode { Should -Be 'Integrated' }

### EXAMPLE 3
```
AppPool TestSite ProcessModel.IdentityType { Should -Be 'ApplicationPoolIdentity'}
```

Title: Test a nested property of the AppPool

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
The Property to be expanded.
If Ommitted, Property Will Default to Status.
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
Assertions: Be

## RELATED LINKS

[A related link]()

[[Invoke-Infraspective](Invoke-Infraspective.md)]()

