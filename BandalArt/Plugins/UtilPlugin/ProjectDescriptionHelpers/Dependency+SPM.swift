//
//  Dependency+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/21.
//

import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

//public extension Package {
//  static let SnapKit = Package.remote(
//    url: "https://github.com/SnapKit/SnapKit.git",
//    requirement: .upToNextMajor(from: "5.6.0")
//  )
//  static let Lottie = Package.remote(
//    url: "https://github.com/airbnb/lottie-ios.git",
//    requirement: .upToNextMajor(from: "4.2.0")
//  )
//  static let Kingfisher = Package.remote(
//    url: "https://github.com/onevcat/Kingfisher.git",
//    requirement: .upToNextMajor(from: "7.8.1")
//  )
//  static let CombineCocoa = Package.remote(
//    url: "https://github.com/CombineCommunity/CombineCocoa.git",
//    requirement: .branch("main")
//  )
//  static let Moya = Package.remote(
//    url: "https://github.com/Moya/Moya.git",
//    requirement: .upToNextMajor(from: "15.0.3")
//  )
//}

public extension TargetDependency.SPM {
  static let SnapKit = TargetDependency.package(product: "SnapKit")
  static let Lottie = TargetDependency.package(product: "Lottie")
  static let Kingfisher = TargetDependency.package(product: "Kingfisher")
  static let CombineCocoa = TargetDependency.package(product: "CombineCocoa")
  static let Moya = TargetDependency.package(product: "Moya")
}
