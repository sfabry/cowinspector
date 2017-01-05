import qbs 1.0
import qbs.TextFile
import qbs.File

Project {
    name: "Cow Inspector"
    minimumQbsVersion: "1.4"
    qbsSearchPaths: "qbs"

    property bool generateTranslations: true
    property bool removeOldTranslations: false

    property bool buildTraceInRelease: true

    property string rootInstall: "../.."
    property string binInstall: "../../" + (qbs.buildVariant == "debug" ? "bin_debug_" : "bin_") + qbs.architecture
    property string installerInstall: "../../installers"
    property string translationInstall: "../../translations"
    property string configInstall: "../../config"

    references: [
        "src/app.qbs",
        "installers/cowinspector.qbs"
    ]

    Product {
        name: "French translation"
        Depends { name: "Qt.core" }
        Group {
            prefix: "translations/fr/"
            files: "*.ts"
        }
        Group {
             fileTagsFilter: "qm"
             qbs.install: true
             qbs.installDir: project.translationInstall
        }
    }
}
