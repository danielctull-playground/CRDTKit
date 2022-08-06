// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "CRDTKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(name: "CRDTKit", targets: ["CRDTKit"]),
        .library(name: "CRDTTest", targets: ["CRDTTest"]),
        .library(name: "CRDTUI", targets: ["CRDTUI"]),
    ],
    targets: [

        .target(
            name: "CRDTKit"),

        .target(
            name: "CRDTTest",
            dependencies: ["CRDTKit"]),

        .target(
            name: "CRDTUI",
            dependencies: ["CRDTKit"]),

        .testTarget(
            name: "CRDTKitTests",
            dependencies: ["CRDTKit", "CRDTTest"]),
    ]
)
