---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-Http.md
schema: 2.0.0
---

# Measure-Http

## SYNOPSIS

Test a Web Service

## SYNTAX

```powershell
Measure-Http [-Target] <String> [-Property] <String> [-Should] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION

Test that a Web Service is reachable and optionally returns specific content.

## EXAMPLES

### EXAMPLE 1: Test the status code of a request

```powershell
Http http://localhost StatusCode { Should -Be 200 }
```

### EXAMPLE 2: Test the content of a request

```powershell
Http http://localhost RawContent { Should -Match 'X-Powered-By: ASP.NET' }
```

### EXAMPLE 3: Test the content does not match

```powershell
Http http://localhost RawContent { Should -Not -Match 'X-Powered-By: Cobal' }
```

## PARAMETERS

### -Target

Specifies the Uniform Resource Identifier (URI) of the Internet resource to
which the web request is sent.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uri

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property

Specifies a property of the WebResponseObject object to test.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction,
-ErrorVariable, -InformationAction, -InformationVariable, -OutVariable,
-OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see
[about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Assertions: Be, BeExactly, Match, MatchExactly

## RELATED LINKS
