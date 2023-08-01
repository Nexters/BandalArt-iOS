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
        public struct Domain {}
        public struct Core {}
        public struct Shared {}
    }
}

public extension TargetDependency.Project.Feature {
    static let CommonFeature = TargetDependency.feature(target: "CommonFeature", path: "Common")
    static let HomeFeature = TargetDependency.feature(target: "HomeFeature", path: "Home")
    static let BottomSheetFeature = TargetDependency.feature(target: "BottomSheetFeature", path: "BottomSheet")
    static let SettingFeature = TargetDependency.feature(target: "SettingFeature", path: "Setting")
    static let OnBoardingFeature = TargetDependency.feature(target: "OnBoardingFeature", path: "OnBoarding")
}

public extension TargetDependency.Project.Domain {
    static let Entity = TargetDependency.domain(name: "Entity")
    static let UseCase = TargetDependency.domain(name: "UseCase")
    static let Interface = TargetDependency.domain(name: "Interface")
}

public extension TargetDependency.Project.Core {
    static let Network = TargetDependency.core(name: "Network")
}

public extension TargetDependency.Project.Shared {
    static let Components = TargetDependency.shared(name: "Components")
    static let Util = TargetDependency.shared(name: "Util")
}
