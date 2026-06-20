// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "5.0.0"

// One checksum per prebuilt tier. All three xcframeworks expose the same
// `opencv2` module, so consumer code (`import opencv2`) is identical regardless
// of the tier chosen — pick exactly ONE product below.
let coreChecksum = "2c99ce47c7bf43e74f1ecc8759614c07fa1faf98fb830b1feacfae1313b76552"
let nodnnChecksum = "2c99ce47c7bf43e74f1ecc8759614c07fa1faf98fb830b1feacfae1313b76552"
let fullChecksum = "2c99ce47c7bf43e74f1ecc8759614c07fa1faf98fb830b1feacfae1313b76552"

func opencvTarget(name: String, checksum: String) -> Target {
    .binaryTarget(
        name: name,
        url: "https://github.com/yeatse/opencv-spm/releases/download/\(version)/\(name).xcframework.zip",
        checksum: checksum
    )
}

let package = Package(
    name: "OpenCV",
    platforms: [
        .macOS(.v10_13), .iOS(.v12), .macCatalyst(.v13), .visionOS(.v1)
    ],
    products: [
        // Full build — every module, including dnn and ptcloud.
        .library(
            name: "OpenCV",
            targets: ["opencv2-full", "opencv2-dependencies"]),
        // Everything except the deep-learning (dnn) module — the largest single
        // contributor to binary size.
        .library(
            name: "OpenCV-NoDNN",
            targets: ["opencv2-nodnn", "opencv2-dependencies"]),
        // Minimal — core, imgproc, imgcodecs and geometry only.
        .library(
            name: "OpenCV-Core",
            targets: ["opencv2-core", "opencv2-dependencies"]),
    ],
    targets: [
        opencvTarget(name: "opencv2-full", checksum: fullChecksum),
        opencvTarget(name: "opencv2-nodnn", checksum: nodnnChecksum),
        opencvTarget(name: "opencv2-core", checksum: coreChecksum),
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
