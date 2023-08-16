// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.6.0"),
        .package(url: "https://github.com/CombineCommunity/CombineCocoa.git", branch: "main"),
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.3"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", exact: "4.2.0"),
        .package(url: "https://github.com/scalessec/Toast-Swift", branch: "master"),
    ]
)