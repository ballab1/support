package org.home.builds.compose;

import org.gradle.api.Plugin
import org.gradle.api.Project

class PdrBuildPlugin implements Plugin<Project> {
    @Override
    void apply(Project project) {
        project.extensions.create('pdrbuild', PdrBuild, project)
    }
}
