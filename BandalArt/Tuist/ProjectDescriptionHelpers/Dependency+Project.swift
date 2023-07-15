//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/15.
//

import ProjectDescription

public extension TargetDependency {
    enum Projcet {}
}

public extension TargetDependency.Projcet {
  static let Feature = TargetDependency.project(target: "Feature", path: .relativeToRoot("Projects/Feature"))
  static let Domain = TargetDependency.project(target: "Domain", path: .relativeToRoot("Projects/Domain"))
  static let Core = TargetDependency.project(target: "Core", path: .relativeToRoot("Projects/Core"))
  static let Shared = TargetDependency.project(target: "Shared", path: .relativeToRoot("Projects/Shared"))
  static let ThirdParty = TargetDependency.project(target: "ThirdParty", path: .relativeToRoot("Projects/ThirdParty"))
}
