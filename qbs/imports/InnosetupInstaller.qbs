import qbs 1.0
import qbs.TextFile
import qbs.Environment

Product  {
    property string appId: ""
    property string setupExtension: ""
    type: "maestro_innosetup"

    condition: qbs.buildVariant == "release" && Environment.getEnv("path").contains("miktex")

    Depends { name: "innosetup" }

    Group {
        fileTagsFilter: "maestro_innosetup"
        qbs.install: true
        qbs.installDir: project.installerInstall
    }
}
