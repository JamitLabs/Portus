// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Portus",
    platforms: [.iOS("8.0"), .tvOS("9.0")],
    products: [
        .library(name: "Portus", targets: ["Portus"])
    ],
    dependencies: [
        .package(url: "https://github.com/Flinesoft/Imperio.git", .exact("3.0.2")),
    ],
    targets: [
        .target(
            name: "Portus",
            dependencies: [
                "Imperio"
            ],
            path: "Frameworks/Portus",
            exclude: ["Frameworks/SupportingFiles"]
        ),
        .testTarget(
            name: "PortusTests",
            dependencies: ["Portus"],
            exclude: ["Tests/SupportingFiles"]
        )
    ]
)