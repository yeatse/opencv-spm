// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "4.7.0"
let checksum = "7e578f7734ff25796acc2847163c86c857a11351a2f99b220d11189639786ee9"

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
