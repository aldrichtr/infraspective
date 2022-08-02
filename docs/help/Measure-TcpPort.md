---
external help file: infraspective-help.xml
Module Name: infraspective
online version: https://github.com/aldrichtr/infraspective/blob/main/docs/help/Measure-TcpPort.md
schema: 2.0.0
---

# Measure-TcpPort

## SYNOPSIS
Test a a Tcp Port.

## SYNTAX

```
Measure-TcpPort [-Target] <String> [-Qualifier] <String> [-Property] <String> [-Should] <ScriptBlock>
 [<CommonParameters>]
```

## DESCRIPTION
Test that a Tcp Port is listening and optionally validate any TestNetConnectionResult property.

## EXAMPLES

### EXAMPLE 1
```
TcpPort localhost 80 PingSucceeded  { Should Be $true }
```

### EXAMPLE 2
```
TcpPort localhost 80 TcpTestSucceeded { Should Be $true }
```

## PARAMETERS

### -Target
Specifies the Domain Name System (DNS) name or IP address of the target computer.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ComputerName

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Qualifier
Specifies the TCP port number on the remote computer.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Port

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
Specifies a property of the TestNetConnectionResult object to test.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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
Position: 5
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
