// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "CRDTKit",
    products: [
        .library(name: "CRDTKit", targets: ["CRDTKit"]),
        .library(name: "CRDTTest", targets: ["CRDTTest"]),
    ],
    targets: [

        .target(
            name: "CRDTKit"),

        .target(
            name: "CRDTTest",
            dependencies: ["CRDTKit"]),

        .testTarget(
            name: "CRDTKitTests",
            dependencies: ["CRDTKit", "CRDTTest"]),
    ]
)
