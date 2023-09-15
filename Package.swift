// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "4.8.0"
let checksum = "6683cac108e7302b73b04f16e6fb631ff7eb17f17e6d2398564e9bbe774068eb"

let package = Package(
    name: "OpenCV",
    platforms: [
        .macOS(.v10_13), .iOS(.v11), .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "OpenCV",
            targets: ["opencv2", "opencv2-dependencies"]),
    ],
    targets: [
        .binaryTarget(name: "opencv2",
                      url: "https://github.com/gamechanger/opencv-spm/releases/download/\(version)/opencv2.xcframework.zip",
                      checksum: checksum),
        .target(
            name: "opencv2-dependencies",
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreImage"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreVideo", .when(platforms: [.iOS])),
                .linkedFramework("Accelerate", .when(platforms: [.iOS, .macOS])),
                .linkedFramework("OpenCL", .when(platforms: [.macOS])),
                .linkedLibrary("c++")
            ]
        )
    ]
)
