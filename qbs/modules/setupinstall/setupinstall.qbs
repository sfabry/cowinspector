import qbs 1.0
import qbs.TextFile
import qbs.FileInfo
import qbs.ModUtils

Module {
    id: setupinstallBuilder
    property string deployPath: ""
    property bool overwrite: true

    Rule {
        inputs: ["ino", "dynamiclibrary", "maestro_pluginspec"]

        Artifact {
            fileTags: ["setupInstall"]
            filePath: input.baseDir + '/' + input.fileName + '.iss'
        }

        prepare : {
            var cmd = new JavaScriptCommand();
            cmd.deployPath = ModUtils.moduleProperty(input, 'deployPath');
            cmd.overwrite = ModUtils.moduleProperty(input, 'overwrite');
            cmd.description = "Write setup install tag file :" + output.filePath + " - " + (cmd.overwrite ? "overwrite" : "not overwrite")
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine("Source: " + FileInfo.toWindowsSeparators(input.filePath) +
                               "; DestDir: \{app\}\\" + FileInfo.toWindowsSeparators(deployPath) +
                               (overwrite ? " ;" : "; Flags: onlyifdoesntexist ;"));
                file.close();
            }
            return cmd;
        }
    }
}
