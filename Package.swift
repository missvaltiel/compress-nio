// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "compress-nio",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13)],
    products: [
        .library(name: "CompressNIO", targets: ["CompressNIO"]),
    ],
    dependencies: [
        // Using local swift-nio fork with Windows fixes
        .package(path: "../swift-nio"),
    ],
    targets: [
        .target(name: "CompressNIO", dependencies: [
            .product(name: "NIOCore", package: "swift-nio"),
            .byName(name: "CCompressZlib")
        ]),
        .target(
            name: "CCompressZlib",
            dependencies: [],
            cSettings: [
                // Windows: use vcpkg zlib headers
                .unsafeFlags(["-I", "C:/Users/missv/Projects/Discord/ScribeSquid/vcpkg_installed/x64-windows/include"], .when(platforms: [.windows]))
            ],
            linkerSettings: [
                // macOS/Linux: link system zlib as 'z'
                .linkedLibrary("z", .when(platforms: [.macOS, .linux])),
                // Windows: link vcpkg zlib (named 'zlib' not 'z')
                .linkedLibrary("zlib", .when(platforms: [.windows])),
                .unsafeFlags(["-L", "C:/Users/missv/Projects/Discord/ScribeSquid/vcpkg_installed/x64-windows/lib"], .when(platforms: [.windows]))
            ]
        ),
        .testTarget(name: "CompressNIOTests", dependencies: ["CompressNIO"]),
    ]
)
