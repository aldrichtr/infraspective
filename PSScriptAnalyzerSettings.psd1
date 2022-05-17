@{
    #region Severity
    # Severity              = @()
    #endregion Severity

    #region ExcludeRules
    # Omits the specified rules from the Script Analyzer test. Wildcard characters are supported.

    # Enter a comma-separated list of rule names, a variable that contains rule names, or a command that gets rule names. You can also specify a list of excluded rules in a Script Analyzer profile file. You
    # can exclude standard rules and rules in a custom rule path.

    # When you exclude a rule, the rule does not run on any of the files in the path. To exclude a rule on a particular line, parameter, function, script, or class, adjust the Path parameter or suppress the
    # rule. For information about suppressing a rule, see the examples.

    # If a rule is specified in both the ExcludeRule and IncludeRule collections, the rule is excluded.
    ExcludeRules          = @(
        "PSDSCDscExamplesPresent",
        "PSDSCDscTestsPresent",
        "PSDSCReturnCorrectTypesForDSCFunctions",
        "PSDSCUseIdenticalMandatoryParametersForDSC",
        "PSDSCUseIdenticalParametersForDSC",
        "PSDSCStandardDSCFunctionsInResource",
        "PSDSCUseVerboseMessageInDSCResource"
    )
    #endregion ExcludeRules

    #region IncludeDefaultRules
    # Invoke default rules along with Custom rules.
    IncludeDefaultRules   = $true
    #endregion IncludeDefaultRules

    #region IncludeRules
    # Runs only the specified rules in the Script Analyzer test. By default, PSScriptAnalyzer runs all
    # rules.

    # Enter a comma-separated list of rule names, a variable that contains rule names, or a command that
    # gets rule names. Wildcard characters are supported. You can also specify rule names in a Script
    # Analyzer profile file.

    # When you use the **CustomizedRulePath** parameter, you can use this parameter to include standard
    # rules and rules in the custom rule paths.

    # If a rule is specified in both the **ExcludeRule** and **IncludeRule** collections, the rule is
    # excluded.

    # The **Severity** parameter takes precedence over **IncludeRule**. For example, if **Severity** is
    # `Error`, you cannot use **IncludeRule** to include a `Warning` rule.
    # IncludeRules          = @()
    #endregion IncludeRules

    #region Rules
    # Some rules have their own settings.  Rules is a hash of Rule names with
    # the rule settings as a hash, like
    # ``` powershell
    # @{
    #     'Rules' = @{
    #         'PSAvoidUsingCmdletAliases' = @{
    #             'allowlist' = @('cd')
    #         }
    #     }
    # }
    # ```
    Rules                 = @{
        PSAvoidUsingCmdletAliases = @{
            Whitelist = @(
                'task'
            )
        }
    }
    #endregion Rules

    #region CustomRulePath
    # Uses only the custom rules defined in the specified paths to the analysis. To still use the built-in rules, add the -IncludeDefaultRules switch.

    # Enter the path to a file that defines rules or a directory that contains files that define rules. Wildcard characters are supported. To add rules defined in subdirectories of the path, use the
    # RecurseCustomRulePath parameter.

    # By default, Invoke-ScriptAnalyzer uses only rules defined in the Microsoft.Windows.PowerShell.ScriptAnalyzer.BuiltinRules.dll file in the PSScriptAnalyzer module.

    # If Invoke-ScriptAnalyzer cannot find rules in the CustomRulePath, it runs the standard rules without notice.

    CustomRulePath        = @(
        ".\.buildtool\pssa_rules\*"
    )
    #endregion CustomRulePath

    #region RecurseCustomRulePath
    # Adds rules defined in subdirectories of the **CustomRulePath** location. By default,
    # `Invoke-ScriptAnalyzer` uses only the custom rules defined in the specified file or directory. To
    # include the built-in rules, use the **IncludeDefaultRules** parameter.
    RecurseCustomRulePath = $true
    #endregion RecurseCustomRulePath
}
