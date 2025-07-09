// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName = "THEOplayerWrapper"

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v13)  // Specify platform compatibility
    ],
    products: [
        .library(
            name: packageName,
            targets: [packageName]
        ),
    ],
    dependencies: [
        // Add the Git URL package dependency here
        .package(url: "https://github.com/FastPix/iOS-core-data-sdk.git", from: "1.0.3"),
        .package(url: "https://github.com/THEOplayer/theoplayer-sdk-apple.git", from: "9.0.0")
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [
                .product(name: "FastpixiOSVideoDataCore", package: "iOS-core-data-sdk"), // Link the Git package to your local package
                .product(name: "THEOplayerSDK",package: "theoplayer-sdk-apple")
            ]
        ),
        .testTarget(
            name: "\(packageName)Tests",
            dependencies: [.target(name: packageName)]
        ),
    ]
)
