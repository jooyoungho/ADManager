// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ADManager",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ADManager",
            targets: ["ADManager"]),
    ],
    dependencies: [
        .package(
          url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
          "11.1.0"..<"20.0.0"
        )
    ],
    targets: [
        .target(
            name: "ADManager",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ]),
        .testTarget(
            name: "ADManagerTests",
            dependencies: ["ADManager"]),
    ]
)
