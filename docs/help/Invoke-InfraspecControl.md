---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Invoke-InfraspecControl.md
schema: 2.0.0
---

# Invoke-InfraspecControl

## SYNOPSIS
A security control consisting of one or more tests and metadata about the test.

## SYNTAX

```
Invoke-InfraspecControl [-Name] <String> [[-Body] <ScriptBlock>] [-Impact <String>] [-Title <String>]
 [-Reference <String[]>] [-Tags <String[]>] [-Resource <String>] [-Description <String[]>] [<CommonParameters>]
```

## DESCRIPTION
This function is aliased by the \`Control\` keyword, and maps directly to the concept of a Security Control
found in many frameworks such as CIS, STIG, HIPAA, etc. 
A control consists of one or more tests, such as
the existence of a file permission, or the status of a service and maps that to a recommended setting for
that test found in one of those frameworks, or your corporate or personal security policy.

A passing test(s) means that the system under test complies with the given control, while a failing test
means that the system is not in compliance The tests are regular Pester tests, using the standard
"Describe/Context/It/Should" keywords. 
These tests are passed directly to Pester (Invoke-Pester) and the
results are returned.

## EXAMPLES

### EXAMPLE 1
```
Control "xccdf_blah" -Resource "Windows" -Impact 1 -Reference 'CVE:123' {
    Describe "cis control 123" {
        It "Should have foo set to bar" {
            $p.foo | Should -Be "bar"
        }
    }
}
```

## PARAMETERS

### -Name
The unique ID for this control

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
The tests associated with this control

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Impact
The criticality, if this control fails

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
The human readable title

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reference
References to external tools and databases
By convention, these are listed as an array of strings in the form of \`\< standard \>: \< id \>\` such as:
\`\`\`powershell
@('CVE: CVE-2022-33915', ')

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Tags associated with this control

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Resource
The type of resource to test

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
An optional description of the test

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
