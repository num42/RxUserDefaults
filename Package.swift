// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RxUserDefaults",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "RxUserDefaults",
      targets: ["RxUserDefaults"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/ReactiveX/RxSwift",
      .upToNextMajor(from: "6.6.0")
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "RxUserDefaults",
      dependencies: [
        .product(name: "RxSwift", package: "RxSwift"),
        .product(name: "RxCocoa", package: "RxSwift")
      ],
      resources: [.copy("PrivacyInfo.xcprivacy")]
    ),
    .testTarget(
      name: "RxUserDefaultsTests",
      dependencies: [
        "RxUserDefaults",
        .product(name: "RxBlocking", package: "RxSwift"),
        .product(name: "RxTest", package: "RxSwift")
      ]
    )
  ]
)
