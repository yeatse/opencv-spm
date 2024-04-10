// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "4.9.0+14"
let checksum = "219ee04857b33bdc5c0a9bef1b2854525b3dfc31140f1f2084abb05b79f293c0"

let package = Package(
    name: "OpenCV",
    platforms: [
        .macOS(.v10_13), .iOS(.v12), .macCatalyst(.v13), .visionOS(.v1)
    ],
    products: [
        .library(
            name: "OpenCV",
            targets: ["opencv2", "opencv2-dependencies"]),
    ],
    targets: [
        .binaryTarget(name: "opencv2",
                      url: "https://github.com/yeatse/opencv-spm/releases/download/\(version)/opencv2.xcframework.zip",
                      checksum: checksum),
        .target(
            name: "opencv2-dependencies",
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreImage"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreVideo", .when(platforms: [.iOS, .visionOS])),
                .linkedFramework("Accelerate", .when(platforms: [.iOS, .macOS, .visionOS])),
                .linkedFramework("OpenCL", .when(platforms: [.macOS])),
                .linkedLibrary("c++")
            ]
        )
    ]
)
