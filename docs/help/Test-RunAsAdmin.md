---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Test-RunAsAdmin.md
schema: 2.0.0
---

# Test-RunAsAdmin

## SYNOPSIS

Verifies if the current process is run as admin.

## SYNTAX

```powershell
Test-RunAsAdmin [<CommonParameters>]
```

## DESCRIPTION

This function verifies whether the current process is running with administrator
rights or not.  If so, it will return a value of $true; otherwise it will return
a value of $false

## EXAMPLES

### EXAMPLE 1

```powershell
if (Test-RunAsAdmin) {
    "I am admin"
} else {
    "I am not"
}
```

## PARAMETERS

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
