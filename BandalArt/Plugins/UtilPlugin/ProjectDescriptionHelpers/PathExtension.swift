//
//  PathExtension.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/21.
//

import Foundation
import ProjectDescription

extension ProjectDescription.Path {
    static func relativeToXCConfig(type: ProjectDeployTarget, name: String) -> Self {
      return .relativeToRoot("XCConfig/\(name)/\(type.rawValue).xcconfig")
    }
    static func relativeToFeature(_ path: String) -> Self {
        return .relativeToRoot("Projects/Feature/\(path)")
    }
    static func relativeToSections(_ path: String) -> Self {
        return .relativeToRoot("Projects/\(path)")
    }
    static func relativeToDomain(_ path: String) -> Self {
        return .relativeToRoot("Projects/Domain/\(path)")
    }
    static func relativeToCore(_ path: String) -> Self {
        return .relativeToRoot("Projects/Core/\(path)")
    }
    static func relativeToShared(_ path: String) -> Self {
        return .relativeToRoot("Projects/Shared/\(path)")
    }
    static var app: Self {
        return .relativeToRoot("Projects/App")
    }
}

extension TargetDependency {
    static func feature(target: String, path: String) -> Self {
        return .project(target: target, path: .relativeToFeature(path))
    }
    static func domain(name: String) -> Self {
        return .project(target: name, path: .relativeToDomain(name))
    }
    static func core(name: String) -> Self {
        return .project(target: name, path: .relativeToCore(name))
    }
    static func shared(name: String) -> Self {
        return .project(target: name, path: .relativeToShared(name))
    }
}
