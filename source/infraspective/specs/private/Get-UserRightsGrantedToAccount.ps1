
function Get-UserRightsGrantedToAccount {
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
        [Alias('User', 'Username')]
        [String[]]$Account,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [String]$ComputerName
    )
    process {
        $lsa = New-Object PS_LSA.LsaWrapper($ComputerName)
        foreach ($Acct in $Account) {
            $output = @{'Account'=$Acct; 'Right'=$lsa.EnumerateAccountPrivileges($Acct); }
            Write-Output (New-Object -TypeName PSObject -Prop $output)
        }
    }
}
