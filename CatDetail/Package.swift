// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CatDetail",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CatDetail",
            targets: ["CatDetail"]),
    ],
    dependencies: [
        .package(name: "ReSwift", url: "https://github.com/ReSwift/ReSwift.git", from: "6.0.0"),
        .package(name: "ReSwiftThunk", url: "https://github.com/ReSwift/ReSwift-Thunk.git", from: "2.0.0"),
        .package(name: "Data", path: "../Data"),
        .package(name: "Store", path: "../Store")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CatDetail",
            dependencies: ["ReSwift",
                           "ReSwiftThunk",
                           "Data",
                           "Store"]),
        .testTarget(
            name: "CatDetailTests",
            dependencies: ["CatDetail"]),
    ]
)
