import qbs 1.0
import qbs.TextFile
import qbs.FileInfo
import qbs.ModUtils

Module {
    id: innosetupBuilder

    Rule {
        multiplex: true
        inputs: ["setupInstall"]
        inputsFromDependencies: ["setupInstall", "application"]

        Artifact {
            fileTags: ["maestro_innosetup"]
            filePath: project.buildDirectory + "/" + product.targetName + ".iss"
        }

        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.installerName = product.targetName
            cmd.version = project.maestro_version
            cmd.filePath = project.buildDirectory + "/" + product.targetName + ".iss"
            cmd.description = "Write innosetup file: " + cmd.filePath
            cmd.architecture = product.moduleProperty("qbs", "architecture")

            // Little hack, read qt lib path from a special Artifact created in Core plugin
            cmd.vcredistPath = FileInfo.toWindowsSeparators(product.sourceDirectory) + "\\..\\microsoft"
            cmd.qtBinPath = "C:\\Qt\\5.7\\msvc2013_64\\bin";
            cmd.qtPluginPath = "C:\\Qt\\5.7\\msvc2013_64\\plugins";
            cmd.qtQmlPath = "C:\\Qt\\5.7\\msvc2013_64\\qml";
            cmd.appId = product.appId
            cmd.setupExtension = product.setupExtension

            // List files to deploy
            cmd.setupInstalls = [];
            for (i in inputs.setupInstall) {
                var ifile = new TextFile(inputs.setupInstall[i].filePath, TextFile.ReadOnly);
                cmd.setupInstalls.push(ifile.readLine());
            }
            for (i in inputs.application) {
                cmd.setupInstalls.push("Source: " + FileInfo.toWindowsSeparators(inputs.application[i].filePath) + "; DestDir: \{app\}\\bin;")
            }

            // Run through all dependencies (first and second level)
            var alldeps = [];
            var deps = product.dependencies;
            for (var d in deps) {
                if (!alldeps.contains(deps[d].name)) alldeps.push(deps[d].name);
                var depdeps = deps[d].dependencies;
                for (var dd in depdeps) {
                    if (!alldeps.contains(depdeps[dd].name)) alldeps.push(depdeps[dd].name);
                }
            }

            // Search for Qt modules
            cmd.qt_depends = [];
            for (var d in alldeps) {
                var qtdept = alldeps[d]
                if (qtdept && qtdept.startsWith("Qt")) {
                    var qtmodule = FileInfo.fileName(qtdept);
                    if (!qtmodule.startsWith("Qt.ax")) cmd.qt_depends.push(qtmodule.charAt(3).toUpperCase() + qtmodule.slice(4));
                }
            }
            cmd.qt_depends.push("QuickTemplates2")

            cmd.sourceCode = function() {
                var file = new TextFile(filePath, TextFile.WriteOnly);
                file.writeLine("[Setup]");
                if (architecture === "x86_64") {
                    file.writeLine("ArchitecturesInstallIn64BitMode=x64");
                    file.writeLine("ArchitecturesAllowed=x64");
                }
                file.writeLine("AppId=" + appId);
                file.writeLine("AppName=CowInspector");
                file.writeLine("AppVersion=" + version);
                file.writeLine("AppPublisher=X-Ray Imaging Solutions (XRIS)");
                file.writeLine("AppPublisherURL=http://www.xris.eu/");
                file.writeLine("AppSupportURL=http://www.xris.eu/");
                file.writeLine("AppUpdatesURL=http://www.xris.eu/");
                file.writeLine("AllowNoIcons=yes");
                file.writeLine("DefaultDirName=\{sd\}\\CowInspector" + setupExtension);
                file.writeLine("DefaultGroupName=CowInspector" + setupExtension);
                file.writeLine("OutputDir=.");
                file.writeLine("OutputBaseFilename=CowInspector_setup" + setupExtension);
                file.writeLine("Compression=lzma");
                file.writeLine("SolidCompression=yes");
                file.writeLine("ChangesAssociations=yes");
                file.writeLine("");
                file.writeLine("[Languages]");
                file.writeLine("Name: \"english\"; MessagesFile: \"compiler:Default.isl\"");
                file.writeLine("Name: \"dutch\"; MessagesFile: \"compiler:Languages\\Dutch.isl\"");
                file.writeLine("Name: \"french\"; MessagesFile: \"compiler:Languages\\French.isl\"");
                file.writeLine("Name: \"german\"; MessagesFile: \"compiler:Languages\\German.isl\"");
                file.writeLine("");
                file.writeLine("[Tasks]");
                file.writeLine("Name: \"desktopicon\"; Description: \"\{cm:CreateDesktopIcon\}\"; GroupDescription: \"\{cm:AdditionalIcons\}\"; Flags: unchecked");
                file.writeLine("Name: \"quicklaunchicon\"; Description: \"\{cm:CreateQuickLaunchIcon\}\"; GroupDescription: \"\{cm:AdditionalIcons\}\"; Flags: unchecked; OnlyBelowVersion: 0,6.1");
                file.writeLine("");
                file.writeLine("[InstallDelete]");

                // We have to list all subdirs of bin in order to avoid removing the ini file there from old installs...
                file.writeLine("Type: files; Name: \"\{app\}\\bin\\*.dll\"");
                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\bin\\Maestro\"");
                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\bin\\platforms\"");
                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\bin\\imageformats\"");
                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\bin\\sqldrivers\"");
                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\bin\\Qt\"");
                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\bin\\QtQml\"");
                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\bin\\QtQuick\"");
                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\bin\\QtQuick.2\"");

                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\plugins\"");
                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\translations\"");
                file.writeLine("Type: filesandordirs; Name: \"\{app\}\\manuals\"");
                file.writeLine("");
                file.writeLine("[Icons]");
                file.writeLine("Name: \"\{group\}\\CowInspector" + setupExtension + "\"; Filename: \"\{app\}\\bin\\CowInspector.exe\"");
                file.writeLine("Name: \"\{group\}\\{cm:ProgramOnTheWeb,CowInspector\}\"; Filename: \"http://www.xris.eu/\"");
                file.writeLine("Name: \"\{group\}\\{cm:UninstallProgram,CowInspector\}\"; Filename: \"\{uninstallexe\}\"");
                file.writeLine("Name: \"\{commondesktop\}\\CowInspector\"; Filename: \"\{app\}\\bin\\CowInspector.exe\"; WorkingDir: \"\{app\}\\bin\"; Tasks: desktopicon");
                file.writeLine("Name: \"\{userappdata\}\\Microsoft\\Internet Explorer\\Quick Launch\\CowInspector" + setupExtension + "\"; Filename: \"\{app\}\\bin\\CowInspector.exe\"; WorkingDir: \"\{app\}\\bin\"; Tasks: quicklaunchicon");
                file.writeLine("");
                file.writeLine("[Run]");
                file.writeLine("Filename: \"\{app\}\\bin\\CowInspector.exe\"; WorkingDir: \"\{app\}\"; Description: \"\{cm:LaunchProgram,CowInspector\}\"; Flags: nowait postinstall skipifsilent");
                file.writeLine("");
                file.writeLine("[Files]");
                file.writeLine("Source: ..\\translations\\*.qm; DestDir: \{app\}\\translations; Flags: skipifsourcedoesntexist");
                file.writeLine("");
                for (i in setupInstalls) {
                    file.writeLine(setupInstalls[i]);
                }
                file.writeLine("");
                file.writeLine("Source: " + qtPluginPath + "\\platforms\\qminimal.dll; DestDir: \{app\}\\bin\\platforms; Flags: ignoreversion recursesubdirs createallsubdirs");
                file.writeLine("Source: " + qtPluginPath + "\\platforms\\qwindows.dll; DestDir: \{app\}\\bin\\platforms; Flags: ignoreversion recursesubdirs createallsubdirs");
                for (i in qt_depends) {
                    file.writeLine("Source: " + qtBinPath + "\\Qt5" + qt_depends[i] + ".dll; DestDir: \{app\}\\bin; Flags: ignoreversion recursesubdirs createallsubdirs");
                }
                file.writeLine("Source: " + qtQmlPath + "\\Maestro\\*; Excludes: \"*.pdb,*d.dll\"; DestDir: \{app\}\\bin\\Maestro; Flags: ignoreversion recursesubdirs createallsubdirs");
                file.writeLine("Source: " + qtQmlPath + "\\Qt\\*; Excludes: \"*.pdb,*d.dll\"; DestDir: \{app\}\\bin\\Qt; Flags: ignoreversion recursesubdirs createallsubdirs");
                file.writeLine("Source: " + qtQmlPath + "\\QtQml\\*; Excludes: \"*.pdb,*d.dll\"; DestDir: \{app\}\\bin\\QtQml; Flags: ignoreversion recursesubdirs createallsubdirs");
                file.writeLine("Source: " + qtQmlPath + "\\QtQuick\\*; Excludes: \"*.pdb,*d.dll\"; DestDir: \{app\}\\bin\\QtQuick; Flags: ignoreversion recursesubdirs createallsubdirs");
                file.writeLine("Source: " + qtQmlPath + "\\QtQuick.2\\*; Excludes: \"*.pdb,*d.dll\"; DestDir: \{app\}\\bin\\QtQuick.2; Flags: ignoreversion recursesubdirs createallsubdirs");
                file.writeLine("Source: " + qtPluginPath + "\\sqldrivers\\qsqlite.dll; DestDir: \{app\}\\bin\\sqldrivers; Flags: ignoreversion recursesubdirs createallsubdirs");
                file.writeLine("Source: " + qtPluginPath + "\\imageformats\\qjpeg.dll; DestDir: \{app\}\\bin\\imageformats; Flags: ignoreversion recursesubdirs createallsubdirs");
                file.writeLine("");

                file.close();
            }
            return cmd;
        }
    }
}
