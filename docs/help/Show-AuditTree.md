---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Show-AuditTree.md
schema: 2.0.0
---

# Show-AuditTree

## SYNOPSIS

Pretty print an Audit AST

## SYNTAX

```powershell
Show-AuditTree [[-Tree] <Object>] [[-Level] <Int32>] [<CommonParameters>]
```

## DESCRIPTION

An Audit AST is a representation of the "Parent-Child" relationship of
Checklists, Controls, etc. Show-AuditTree prints a graphical representation as
an indented list

## EXAMPLES

### EXAMPLE 1

```powershell
Invoke-Infraspective | Show-AuditTree
```

## PARAMETERS

### -Tree

The tree to print

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Level

Current depth

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
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

## RELATED LINKS
