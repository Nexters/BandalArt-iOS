//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by Youngmin Kim on 2023/07/13.
//

import ProjectDescription

//let workspace = Workspace(
//    name: "BandalArt",
//    projects: [
//        "Projects/Feature",
//        "Projects/Domain",
//        "Projects/Core",
//        "Projects/Shared"
//    ]
//)


let workspace = Workspace(
    name: "BandalArt",
    projects: {
        var projects: [Path] = [
            Path("Projects/App"),
        ]
        
        projects += FeatureModule.allCases.map {
            Path("Projects/Feature/\($0.rawValue)")
        }
        
        projects += CoreModule.allCases.map {
            Path("Projects/Core/\($0.rawValue)")
        }
        
        return projects
    }()
)

public enum FeatureModule: String, CaseIterable {
    case Foo
    case Bar
}

public enum CoreModule: String, CaseIterable {
    case Network
    case Database
}
