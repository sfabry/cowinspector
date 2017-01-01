import qbs 1.0

Product {
    Depends { name: "cpp" }
    Depends { name: "Qt.core" }
    Depends { name: "Qt.gui" }
    Depends { name: "Qt.parameter" }

    cpp.includePaths: [project.sourceDirectory + "/maestro/src/shared/"]
    cpp.defines: {
        var defines = [
                    "QSLOG_MODULE=Global",
                    "IDE_VERSION_MAJOR=" + project.maestro_version_major,
                    "IDE_VERSION_MINOR=" + project.maestro_version_minor,
                    "IDE_VERSION_RELEASE=" + project.maestro_version_release
                ]
        if (qbs.buildVariant === "debug") {
            defines.push("MAESTRO_DEBUG")
            defines.push("MAESTRO_LOG_TRACES")
        }
        else {
            if (project.buildTraceInRelease) defines.push("MAESTRO_LOG_TRACES")
            else defines.push("QT_NO_DEBUG_OUTPUT")
        }
        return base.concat(defines)
    }

    cpp.useCxxPrecompiledHeader: true
    Group {
        name: "Precompiled header"
        fileTags: "cpp_pch_src"
        prefix: project.sourceDirectory + "/maestro/src/shared/"
        files: "maestro_gui_pch.h"
    }

    Depends {
        condition: qbs.buildVariant === "release" && project.generateTranslations
        name: "translation"
    }

}
