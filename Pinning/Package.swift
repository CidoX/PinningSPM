// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pinning",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Pinning",
            targets: ["Pinning"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "Pinning",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto")
            ]
        ),
        .testTarget(
            name: "PinningTests",
            dependencies: ["Pinning"]
        ),
    ]
)
