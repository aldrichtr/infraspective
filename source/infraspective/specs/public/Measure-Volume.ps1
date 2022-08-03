
function Measure-Volume {
    <#
    .EXTERNALHELP infraspective-help.xml
    #>
    [Alias('Volume')]
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        [Parameter(
            ParameterSetName = "Default",
            Position = 1,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = "Property",
            Position = 1,
            Mandatory
        )]
        [Alias('Name')]
        [string]$Target,

        [Parameter(
            ParameterSetName = "Property",
            Position = 2
        )]
        [ValidateSet(
            'AllocationUnitSize', 'DedupMode', 'DriveLetter', 'DriveType', 'FileSystem',
            'FileSystemLabel', 'FileSystemType', 'HealthStatus', 'ObjectId', 'OperationalStatus',
            'Path', 'Size', 'SizeRemaining'
        )]
        [string]$Property,

        [Parameter(
            ParameterSetName = "Default",
            Position = 2,
            Mandatory
        )]
        [Parameter(
            ParameterSetName = "Property",
            Position = 3,
            Mandatory
        )]
        [scriptblock]$Should
    )

    begin {
        function getVolume {
            param(
                [Parameter(
                )]
                [string]$Name
            )
            <#
            .SYNOPSIS
                Lookup the volume by drive letter or label
            .DESCRIPTION
                If the Name variable is only one character, lookup volume by driveletter, otherwise
                by label
            #>
            if ($Name.Length -eq 1) {
                $v = Get-Volume -DriveLetter $Name -ErrorAction SilentlyContinue
                if (-not $v) {
                    $v = Get-Volume -FileSystemLabel $Name  -ErrorAction SilentlyContinue
                }
            } else {
                $v = Get-Volume -FileSystemLabel $Name  -ErrorAction SilentlyContinue
            }
            $v
        }
    }
    process {
        $expression = { GetVolume -Name '$Target' }

        $params = Get-PoshspecParam -TestName Volume -TestExpression $expression @PSBoundParameters
    }
    end {
        Invoke-PoshspecExpression @params
    }
}
