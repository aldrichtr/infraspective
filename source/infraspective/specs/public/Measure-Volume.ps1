
function Measure-Volume {
    <#
    .SYNOPSIS
        Test the volume specified
    .DESCRIPTION
        Can be specified to target a specific volume for testing
    .EXAMPLE
        Volume C HealthStatus { Should -Be 'Healthy' }
    .EXAMPLE
        Volume C FileSystem { Should -Be 'NTFS' }
    .EXAMPLE
        Volume D AllocationUnitSize { Should -Cbe 64K }
    .EXAMPLE
        Volume MyFileSystemLabel SizeRemaining { Should -BeGreaterThan 1GB }
    .NOTES
        Assertions: Be
    #>
    [Alias('Volume')]
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        # Specifies the drive letter or file system label of the volume to test
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Default")]
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Property")]
        [Alias('Name')]
        [string]$Target,

        # Specifies an optional property to test for on the volume
        [Parameter(Position = 2, ParameterSetName = "Property")]
        [ValidateSet('AllocationUnitSize', 'DedupMode', 'DriveLetter', 'DriveType', 'FileSystem', 'FileSystemLabel',
        'FileSystemType', 'HealthStatus', 'ObjectId', 'OperationalStatus', 'Path', 'Size', 'SizeRemaining')]
        [string]$Property,

        # A Script Block defining a Pester Assertion.
        [Parameter(Mandatory, Position = 2, ParameterSetName = "Default")]
        [Parameter(Mandatory, Position = 3, ParameterSetName = "Property")]
        [scriptblock]$Should
    )

    begin {
        function GetVolume([string]$Name) {
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
