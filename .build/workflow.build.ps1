<#
.SYNOPSIS
    A workflow is a collection of tasks that achieve a specific stage or phase of the dev process.
.DESCRIPTION
    Phases:
    - Configure
    / add/modify code
    - UnitTest
    - Build
    - IntegrationTest
    - Release
#>


#synopsis: Display helpful content about the build
task ShowBuildHelp {},
output_help_instructions,
output_help_task_tree

#synopsis: Reset the environment
task Clean {
    remove "$Artifact/*" -Verbose
    remove "$Staging/*" -Verbose
},
unregister_project_repo

#synopsis: configure the project is correct and all necessary information is available
task Configure {},
configure_dependencies,
configure_directories,
update_markdown_help

#synopsis: Run the unit tests for the project
pester UnitTest -Type 'Unit' -Output 'Normal' -CodeCov:$CodeCov

#synopsis: Run the integration tests for the project
pester IntegrationTest -Type 'Integration' -Output 'Normal' -CodeCov:$CodeCov

#synopsis: Build the source code (create/assemble a module, manifest and supporting files from source)
task Build {},
    build_module_files,
    make_external_help_maml

#synopsis: Install the modules from the system local PSRepo
task Install {},
    publish_to_local_repo,
    install_modules

#synopsis: Remove and uninstall the module from the system
task Uninstall {},
    uninstall_modules


#synopsis: Create an official release of the modules
task Release {},
    update_source_manifest_version,
    update_doc_help_version,
    update_readme_version,
    update_changlog_to_latest_version,
    Package
    #    tag_latest_version

#synopsis: package the staged module to a nuget package file (.nupkg)
task Package {},
    Build,
    update_module_namespace,
    add_release_notes,
    register_project_repo,
    generate_nuget_package,
    unregister_project_repo


#synopsis: The default task when no task is specified
task . Build
