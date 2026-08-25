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
        .package(url: "https://github.com/FastPix/iOS-core-data-sdk.git", from: "1.0.6"),
        .package(url: "https://github.com/THEOplayer/theoplayer-sdk-apple.git", from: "9.0.0")
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [
                .product(name: "FastpixiOSVideoDataCore", package: "iOS-core-data-sdk"), // Link the Git package to your local package
                .product(name: "THEOplayerSDK",package: "theoplayer-sdk-apple")
            ],
            path: packageName
        ),
        .testTarget(
            name: "\(packageName)Tests",
            dependencies: [.target(name: packageName)],
            path: "\(packageName)Tests"
        ),
    ],
    // This source is not Swift 6 concurrency-clean; build it in Swift 5 language
    // mode (a tools-6.0 manifest would otherwise default targets to Swift 6).
    swiftLanguageModes: [.v5]
)
