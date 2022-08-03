
function Get-AccountsWithUserRight {
    <#
    .EXTERNALHELP infraspective-help.xml
     #>
     [CmdletBinding()]
     param(
        [Parameter(
            Position = 1,
            Mandatory,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline
        )]
        [Alias('Privilege')]
        [PS_LSA.Rights[]]$Right,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [String]$ComputerName
    )
    process {
        $lsa = New-Object PS_LSA.LsaWrapper($ComputerName)
        foreach ($Priv in $Right) {
            $output = @{'Account'=$lsa.EnumerateAccountsWithUserRight($Priv); 'Right'=$Priv; }
            Write-Output (New-Object -TypeName PSObject -Prop $output)
        }
    }
}
