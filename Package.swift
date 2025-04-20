// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "ContactsApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "ContactsApp",
            targets: ["ContactsApp"]
        )
    ],
    targets: [
        .executableTarget(
            name: "ContactsApp",
            dependencies: [],
            path: "ContactsApp"
        )
    ]
) 