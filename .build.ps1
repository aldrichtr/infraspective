param(
    [Parameter()]
    [string]$Source = (
        property Source "$BuildRoot\source"
    ),

    [Parameter()]
    [string]$Staging = (
        property Staging "$BuildRoot\stage"
    ),

    [Parameter()]
    [string]$Tests = (
        property Tests "$BuildRoot\tests"
    ),

    [Parameter()]
    [string]$Artifact = (
        property Artifact "$BuildRoot\out"
    ),

    [Parameter()]
    [string]$Docs = (
        property Docs "$BuildRoot\docs"
    ),

    [Parameter()]
    [switch]$CodeCov = (
        property CodeCov $false
    ),

    [Parameter()]
    [switch]$SkipBuildToolImport = (
        property SkipBuildToolImport $false
    ),

    [Parameter()]
    [switch]$SkipDependencyCheck = (
        property SkipDependencyCheck $false
    ),

    [Parameter()]
    [switch]$CopyEmptySourceDirs = (
        property CopyEmptySourceDirs $false
    )
)

begin {
    if (-not $SkipBuildToolImport) {
        Import-Module BuildTool -ErrorAction SilentlyContinue

        foreach ($file in Get-Command *.ib.tasks -Module BuildTool) { . $file }
        <#------------------------------------------------------------------
         Load any customizations from the .build directory
        ------------------------------------------------------------------#>
        # a task file defines a function used to create build task types
        Get-ChildItem -Path '.build' -Filter '*.task.ps1' | ForEach-Object {
            . $_.FullName
        }
        Get-ChildItem -Path '.build' -Filter '*.build.ps1' | ForEach-Object {
            . $_.FullName
        }
    }


    <#------------------------------------------------------------------
      This alias allows you to call another task from within another task
      without having to re-invoke invoke-build.  That way all of the state
      and properties is preserved.
      Example
      if ($config.Foo -eq 1) {call update_foo}
     #! it is definitely messing with the internals a bit which is not
     #! recommended
    ------------------------------------------------------------------#>
    Set-Alias call *Task

}
process {
    Enter-Build {
        $BuildInfo = Get-BuildConfiguration
    }
    Set-BuildHeader {
        param($Path)
        if ($task.InvocationInfo.ScriptName -like '*workflow.build.ps1') {
            Write-Build Cyan "$('-' * 80)"
        }
        Write-Build Cyan "Begin Task: $($Task.Name.ToUpper() -replace '_', ' ')" (Get-BuildSynopsis $Task)
    }
    Set-BuildFooter {
        param($Path)
        if ($task.InvocationInfo.ScriptName -like '*workflow.build.ps1') {
            Write-Build Cyan "$('-' * 80)"
        }
    }
}
end {
}
