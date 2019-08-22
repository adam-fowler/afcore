// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "afcore",
    platforms: [ .macOS(.v10_12), .iOS(.v10), .tvOS(.v10) ],
    products: [
        .library(name: "afcore", targets: ["afcore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "afcore", dependencies: ["debug"]),
        .target(name: "debug", dependencies: []),
        .testTarget(name: "afcoreTests", dependencies: ["afcore"]),
    ]
)
