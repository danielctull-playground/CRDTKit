// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "CRDTKit",
    products: [
        .library(name: "CRDTKit", targets: ["CRDTKit"]),
    ],
    targets: [

        .target(
            name: "CRDTKit"),

        .testTarget(
            name: "CRDTKitTests",
            dependencies: ["CRDTKit"]),
    ]
)
