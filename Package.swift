// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Portus",
    products: [
        .library(name: "Portus", targets: ["Portus"])
    ],
    dependencies: [
//        .package(url: "https://github.com/Flinesoft/HandySwift.git", .upToNextMajor(from: "2.5.0")),
//        .package(url: "https://github.com/Flinesoft/HandyUIKit.git", .upToNextMajor(from: "1.6.0"))
    ],
    targets: [
        .target(
            name: "Portus",
            dependencies: [
//                "HandySwift",
//                "HandyUIKit"
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
