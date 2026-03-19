// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "compress-nio",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13)],
    products: [
        .library(name: "CompressNIO", targets: ["CompressNIO"]),
    ],
    dependencies: [
        // Using fork with Windows fixes
        .package(url: "https://github.com/missvaltiel/swift-nio.git", branch: "main"),
    ],
    targets: [
        .target(name: "CompressNIO", dependencies: [
            .product(name: "NIOCore", package: "swift-nio"),
            .byName(name: "CCompressZlib")
        ]),
        .target(
            name: "CCompressZlib",
            dependencies: [],
            linkerSettings: [
                .linkedLibrary("z"),
            ]
        ),
        .testTarget(name: "CompressNIOTests", dependencies: ["CompressNIO"]),
    ]
)
