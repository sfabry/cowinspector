import qbs 1.0
import qbs.TextFile

InnosetupInstaller  {
    name: "CowInspector"
    targetName: "CowInspector_" + (qbs.architecture === "x86" ? "32" : "64")
    setupExtension: "_" + (qbs.architecture === "x86" ? "32" : "64")
    appId: qbs.architecture === "x86" ? "\{\{cutesoft.cowinspector.32\}" : "\{\{cutesoft.cowinspector.64\}"

    Depends { name: "Desktop Application" }

}
