import qbs.base 1.0
import qbs.TextFile
import qbs.FileInfo
import qbs.ModUtils
import qbs.File

Module {
    property string tsFileName: product.targetName

    FileTagger {
        patterns: "*.cpp"
        fileTags: ["tr_cpp"]
    }
    FileTagger {
        patterns: "*.h"
        fileTags: ["tr_h"]
    }
    FileTagger {
        patterns: "*.ui"
        fileTags: ["tr_ui"]
    }
    FileTagger {
        patterns: "*.qml"
        fileTags: ["tr_qml"]
    }

    Rule {
        id: translator
        multiplex: true
        inputs: ['tr_cpp', 'tr_h', 'tr_ui', 'tr_qml']
        Artifact {
            fileTags: ["translation_pro"]
            filePath: FileInfo.joinPaths(product.destinationDirectory, ModUtils.moduleProperty(product, "tsFileName") + "_tr.pro");
        }

        prepare: {
            var cmd = new JavaScriptCommand( );
            cmd.description = "Write translation pro file: " + output.filePath
            cmd.silent = true
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine("HEADERS = \\")
                for (i in inputs.tr_h) {
                    file.writeLine(inputs.tr_h[i].filePath + " \\")
                }
                file.writeLine("");
                file.writeLine("SOURCES = \\")
                for (i in inputs.tr_cpp) {
                    file.writeLine(inputs.tr_cpp[i].filePath + " \\")
                }
                for (i in inputs.tr_qml) {
                    file.writeLine(inputs.tr_qml[i].filePath + " \\")
                }
                file.writeLine("");
                file.writeLine("FORMS = \\")
                for (i in inputs.tr_ui) {
                    file.writeLine(inputs.tr_ui[i].filePath + " \\")
                }
                file.writeLine("");
                file.close();
            }

            var languages = ["fr"]
            var trPath = project.sourceDirectory + "/translations/"
            var args = []
            args.push(output.filePath)
            for (i in languages) {
                args.push("-ts")
                args.push(trPath + languages[i] + "/" + product.targetName + "_" + languages[i] + ".ts")
            }
            if (project.removeOldTranslations) args.push("-no-obsolete")
            var cmdUpdate = new Command(product.moduleProperty("Qt.core", "binPath") + "\\lupdate.exe", args)
            cmdUpdate.description = "Update translations of " + product.targetName
            cmdUpdate.silent = true

            if (product.targetName.contains("test")) return cmd;
            else return [cmd, cmdUpdate];
        }
    }
}
