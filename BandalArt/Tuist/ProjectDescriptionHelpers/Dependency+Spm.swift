//
//  Dependency+Spm.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/15.
//

import ProjectDescription

public extension TargetDependency {
  enum SPM {}
}

public extension Package {
  static let CombineCoCoa = Package.remote(
    url: "https://github.com/CombineCommunity/CombineCocoa.git",
    requirement: .upToNextMajor(from: "0.4.1")
  )
  static let Moya = Package.remote(
    url: "https://github.com/Moya/Moya.git",
    requirement: .upToNextMajor(from: "15.0.3")
  )
  static let SnapKit = Package.remote(
    url: "https://github.com/SnapKit/SnapKit.git",
    requirement: .upToNextMajor(from: "5.6.0")
  )
  static let Lottie = Package.remote(
    url: "https://github.com/airbnb/lottie-ios.git",
    requirement: .upToNextMajor(from: "4.2.0")
  )
}

public extension TargetDependency.SPM {
  static let CombineCoCoa = TargetDependency.package(product: "CombineCoCoa")
  static let Moya = TargetDependency.package(product: "Moya")
  static let SnapKit = TargetDependency.package(product: "SnapKit")
  static let Lottie = TargetDependency.package(product: "Lottie")
}
