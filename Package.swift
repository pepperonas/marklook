// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MarkLook",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "MarkLookCore",
            targets: ["MarkLookCore"]
        ),
        .executable(
            name: "MarkLook",
            targets: ["MarkLook"]
        ),
        .executable(
            name: "MarkLookPreview",
            targets: ["MarkLookPreview"]
        ),
        .executable(
            name: "MarkLookTests",
            targets: ["MarkLookTests"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", from: "0.5.0")
    ],
    targets: [
        .target(
            name: "MarkLookCore",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown")
            ],
            path: "Sources/MarkLookCore"
        ),
        .executableTarget(
            name: "MarkLook",
            dependencies: [
                "MarkLookCore"
            ],
            path: "Sources/MarkLook",
            exclude: ["Resources"]
        ),
        .executableTarget(
            name: "MarkLookPreview",
            dependencies: [
                "MarkLookCore"
            ],
            path: "Sources/MarkLookPreview",
            exclude: ["Resources"],
            linkerSettings: [
                .linkedFramework("QuickLookUI"),
                .linkedFramework("Quartz"),
                .linkedFramework("UniformTypeIdentifiers"),
                .linkedFramework("AppKit")
            ]
        ),
        .executableTarget(
            name: "MarkLookTests",
            dependencies: [
                "MarkLookCore"
            ],
            path: "Tests/MarkLookTests"
        )
    ]
)
