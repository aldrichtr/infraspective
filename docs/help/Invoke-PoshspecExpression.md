﻿---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Invoke-PoshspecExpression.md
schema: 2.0.0
---

# Invoke-PoshspecExpression

## SYNOPSIS

Generates a Pester 'It' block using values generated by `Get-PoshspecParam`

## SYNTAX

```powershell
Invoke-PoshspecExpression [-InputObject] <PSObject> [<CommonParameters>]
```

## DESCRIPTION

Generate and return a Pester It block created with the Name and Expression
specified in the input object

## EXAMPLES

### EXAMPLE 1: Create a Pester It to test the temp directory

```powershell
Invoke-PoshspecExpression -InputObject (
    [pscustomobject]@{
        Name = "File 'C:\Temp' Should -Exist"
        Expression = "'C:\Temp' | Should -Exist"
    }
)
```

## PARAMETERS

### -InputObject

Poshspec Param Object

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

This function was originally part of the
[poshspec](https://github.com/Ticketmaster/poshspec) module.  It has been
updated to conform with Pester v5 which added a "Discover" and "Run" phase that
changed the way variables are used.

## RELATED LINKS
