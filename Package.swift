// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "RxUserDefaults",
    products: [
        .library(name: "RxUserDefaults", targets: ["RxUserDefaults"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        .target(
            name: "RxUserDefaults",
            dependencies: ["RxSwift", "RxCocoa"],
            path: "Sources"
        )
    ]
)