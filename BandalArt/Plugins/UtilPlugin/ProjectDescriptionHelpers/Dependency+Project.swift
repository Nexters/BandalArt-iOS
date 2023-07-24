//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/21.
//

import Foundation
import ProjectDescription

public extension TargetDependency {
  struct Project {
    public struct Feature {}
    public struct Core {}
    public struct Shared {}
  }
}

public extension TargetDependency.Project.Feature {
  static let CommonFeature = TargetDependency.feature(name: "CommonFeature")
  static let MainFeature = TargetDependency.feature(name: "MainFeature")
  static let HomeFeature = TargetDependency.feature(name: "HomeFeature")
  static let BottomSheetFeature = TargetDependency.feature(name: "BottomSheetFeature")
  static let SettingFeature = TargetDependency.feature(name: "SettingFeature")
  static let OnboardingFeature = TargetDependency.feature(name: "OnboardingFeature")
}
