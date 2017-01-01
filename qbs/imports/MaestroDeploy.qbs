import qbs 1.0

Product {
    type: "setupInstall"

    Depends { name: "setupinstall" }
    setupinstall.deployPath: "bin"
}
