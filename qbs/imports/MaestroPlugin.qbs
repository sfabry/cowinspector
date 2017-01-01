import qbs 1.0
import qbs.TextFile

MaestroProduct  {
    type: ["setupInstall", "dynamiclibrary", "translation_pro"]

    property string target: ""
    property int licenseId: -1
    property int sortNumber: 0
    property string commercialName: ""
    property string category: "Maestro"
    property string description: "Maestro plugin"
    property bool experimental: false

    // Can't give special names to plugins unless pluginspec dependencies does not have the correct names
    name: target
    targetName: qbs.buildVariant == "debug" ? target + "d" : target

    Depends { name: "Logging" }
    Depends { name: "Extension System" }
    Depends { name: "Utils" }

    Depends { name: "cpp" }
    cpp.defines:
        base.concat(
            [
                target.toUpperCase() + "_LIBRARY",
                "QSLOG_MODULE=" + category
            ])

    cpp.includePaths: base.concat(
                          [
                              ".",
                              ".."
                          ])

    Depends { name: "setupinstall" }
    setupinstall.deployPath: "plugins"

    Depends { name: "pluginspec" }
    Group {
        fileTagsFilter: "maestro_pluginspec"
        qbs.install: true
        qbs.installDir: project.pluginInstall
    }

    Group {
        fileTagsFilter: "dynamiclibrary"
        qbs.install: true
        qbs.installDir: project.pluginInstall
    }

    // All products depending on a plugin will also depends from cpp and get the includepath to the plugin current directory
    Export {
        Depends { name: "cpp" }
        cpp.includePaths: [".", ".."]
    }
}
