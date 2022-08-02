---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-AuditPolicy.md
schema: 2.0.0
---

# Measure-AuditPolicy

## SYNOPSIS
Test an Audit Policy.

## SYNTAX

```
Measure-AuditPolicy [-Qualifier] <String> [-Target] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Test the setting of a particular audit policy .

## EXAMPLES

### EXAMPLE 1
```
AuditPolicy System "Security System Extension" { Should -Be Success }
```

### EXAMPLE 2
```
AuditPolicy "Logon/Logoff" Logon { Should -Be "Success and Failure"  }
```

### EXAMPLE 3
```
AuditPolicy "Account Management" "User Account Management" { Should -Not -Be "No Auditing" }
```

## PARAMETERS

### -Qualifier
Specifies the category of the Audit Policy.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Category

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
Specifies the subcategory of the Audit policy.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Subcategory

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Assertions: Be, BeExactly, Match, MatchExactly

## RELATED LINKS
