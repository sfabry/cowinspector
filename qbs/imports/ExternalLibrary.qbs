import qbs 1.0

Product  {
    type: ["setupInstall", "dynamiclibrary"]
    
    Depends { name: "cpp" }
    
    Depends { name: "setupinstall" }
    setupinstall.deployPath: "bin"

    Group {
        fileTagsFilter: "dynamiclibrary"
        qbs.install: true
        qbs.installDir: project.libInstall
    }
}
