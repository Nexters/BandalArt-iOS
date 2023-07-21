//
//  TargetDependency+Modules.swift
//  ProjectDescriptionHelpers
//
//  Created by Youngmin Kim on 2023/07/21.
//

import ProjectDescription

public enum FeatureModule: String, CaseIterable {
    case Foo
    case Bar
}

public enum CoreModule: String, CaseIterable {
    case Network
    case Database
}

public extension TargetDependency {
    
    private static func feature(target: String, moduleName: String) -> TargetDependency {
        .project(target: target, path: .relativeToRoot("Projects/Feature/" + moduleName))
    }
    
    static func feature(interface moduleName: FeatureModule) -> TargetDependency {
        .feature(target: moduleName.rawValue + "FeatureInterface", moduleName: moduleName.rawValue)
    }
    
    static func feature(implementation moduleName: FeatureModule) -> TargetDependency {
        .feature(target: moduleName.rawValue + "Feature", moduleName: moduleName.rawValue)
    }
    
    static func feature(testing moduleName: FeatureModule) -> TargetDependency {
        .feature(target: moduleName.rawValue + "FeatureTesting", moduleName: moduleName.rawValue)
    }
}


// MARK: - Core

public extension TargetDependency {
    
    private static func core(target: String, moduleName: String) -> TargetDependency {
        .project(target: target, path: .relativeToRoot("Projects/Core/" + moduleName))
    }
    
    static func core(interface moduleName: CoreModule) -> TargetDependency {
        .core(target: moduleName.rawValue + "Interface", moduleName: moduleName.rawValue)
    }
    
    static func core(implementation moduleName: CoreModule) -> TargetDependency {
        .core(target: moduleName.rawValue, moduleName: moduleName.rawValue)
    }
    
    static func core(testing moduleName: CoreModule) -> TargetDependency {
        .core(target: moduleName.rawValue + "Testing", moduleName: moduleName.rawValue)
    }
}
