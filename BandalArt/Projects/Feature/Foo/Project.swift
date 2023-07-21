//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Youngmin Kim on 2023/07/21.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "FooFeature"
private let bundleID = "com.bandal.art.features.foo"
private let iOSTargetVersion = "15.0"

let project = Project.framework(
    name: projectName,
    platform: .iOS,
    bundleID: bundleID,
    dependencies: [
        .project(target: "Network", path: .relativeToRoot("Projects/Core/Network")),
        .project(target: "Shared", path: .relativeToRoot("Projects/Shared")),
        .external(name: "SnapKit"),
        .external(name: "CombineCocoa")
    ]
)

