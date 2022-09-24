// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "4.6.0"
let checksum = "1ead050146646a8f81e37aba0f7efb7033678311734a272f76557647c4d419b2"

let package = Package(
    name: "OpenCV",
    platforms: [
        .macOS(.v10_13), .iOS(.v11), .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "OpenCV",
            targets: ["opencv2"]),
    ],
    targets: [
        .binaryTarget(name: "opencv2",
                      url: "https://github.com/Yeatse/OpenCV-SPM/releases/download/\(version)/opencv2.xcframework.zip",
                      checksum: checksum),
    ]
)
