//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Youngmin Kim on 2023/07/21.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "App"
private let bundleID = "com.bandal.art.app"
private let iOSTargetVersion = "15.0"

let project = Project.app(
    name: projectName,
    platform: .iOS,
    bundleID: bundleID,
    dependencies: [
        .project(target: "BarFeature", path: .relativeToRoot("Projects/Feature/Bar")),
        .project(target: "FooFeature", path: .relativeToRoot("Projects/Feature/Foo"))
    ]
)

