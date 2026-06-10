// Root-level (project-level) build.gradle.kts file (<project>/android/build.gradle.kts)

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Your custom build directory logic
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Ensure evaluation order for dependencies
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}