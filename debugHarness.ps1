Import-Module Pester
$env:PSModulePath += ";$PSScriptRoot\out"
Import-Module ".\source\infraspective\infraspective.psd1" -Force

$r = Invoke-Infraspective .\tests\data\test-one-dot-zero.Audit.ps1
