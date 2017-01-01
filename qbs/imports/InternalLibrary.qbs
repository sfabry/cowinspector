import qbs 1.0

MaestroProduct  {
    type: ["setupInstall", "dynamiclibrary", "translation_pro"]

    Depends { name: "cpp" }
    cpp.defines:
        base.concat(
            [
                targetName.toUpperCase() + "_LIBRARY"
            ])

    Depends { name: "setupinstall" }
    setupinstall.deployPath: "bin"

    // All products depending on a library will also depends from cpp and get the includepath to the library current directory
    Export {
        Depends { name: "cpp" }
        cpp.includePaths: ".."
    }

    Group {
        fileTagsFilter: "dynamiclibrary"
        qbs.install: true
        qbs.installDir: project.libInstall
    }
}
