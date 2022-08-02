---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-Volume.md
schema: 2.0.0
---

# Measure-Volume

## SYNOPSIS
Test the volume specified

## SYNTAX

### Default (Default)
```
Measure-Volume [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

### Property
```
Measure-Volume [-Target] <String> [[-Property] <String>] [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Can be specified to target a specific volume for testing

## EXAMPLES

### EXAMPLE 1
```
Volume C HealthStatus { Should -Be 'Healthy' }
```

### EXAMPLE 2
```
Volume C FileSystem { Should -Be 'NTFS' }
```

### EXAMPLE 3
```
Volume D AllocationUnitSize { Should -Cbe 64K }
```

### EXAMPLE 4
```
Volume MyFileSystemLabel SizeRemaining { Should -BeGreaterThan 1GB }
```

## PARAMETERS

### -Target
Specifies the drive letter or file system label of the volume to test

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
Specifies an optional property to test for on the volume

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
Assertions: Be

## RELATED LINKS
