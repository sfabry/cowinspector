import qbs 1.0
import qbs.TextFile
import qbs.FileInfo

Product {
    type: ["application"]
    name: "Desktop Application"
    targetName: qbs.buildVariant == "debug" ? "cowinspector_debug" : "cowinspector"
    consoleApplication: false

    Depends { name: "cpp" }
    Depends { name: "Qt.core" }
    Depends { name: "Qt.gui" }
    Depends { name: "Qt.quick" }
    Depends { name: "Qt.quickcontrols2" }
    Depends { name: "Qt.sql" }

    cpp.linkerFlags: base.concat([ "/LARGEADDRESSAWARE" ])
    cpp.defines: {
        var defines = []
        if (qbs.buildVariant === "release" && !project.buildTraceInRelease) defines.push("QT_NO_DEBUG_OUTPUT")
        return base.concat(defines)
    }
    cpp.dynamicLibraries: base.concat(["qmllive0"])

    Depends {
        condition: qbs.buildVariant === "release" && project.generateTranslations
        name: "translation"
    }
    
    Group {
        fileTagsFilter: "application"
        qbs.install: true
        qbs.installDir: project.binInstall
    }

    files: [
        "cowdaysmodel.cpp",
        "cowdaysmodel.h",
        "cowmealsmodel.cpp",
        "cowmealsmodel.h",
        "cowinspector.cpp",
        "cowinspector.h",
        "cowsmodel.cpp",
        "cowsmodel.h",
        "identificationModel.cpp",
        "identificationModel.h",
        "logsmodel.cpp",
        "logsmodel.h",
        "main.cpp",
        "querymodel.cpp",
        "querymodel.h",
    ]

    Group {
        name: "qml"
        prefix: "qml/"
        files: "*.qml"
        qbs.install: true
        qbs.installDir: project.binInstall + "/qml"
    }

    Group {
        name: "images"
        prefix: "images/"
        files: "*.*"
        qbs.install: true
        qbs.installDir: project.binInstall + "/images"
    }
}
