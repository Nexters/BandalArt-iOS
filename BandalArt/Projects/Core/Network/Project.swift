//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Youngmin Kim on 2023/07/21.
//

import ProjectDescription
import ProjectDescriptionHelpers


private let projectName = "Network"
private let bundleID = "com.bandal.art.core.network"
private let iOSTargetVersion = "15.0"

let project = Project.framework(
    name: projectName,
    platform: .iOS,
    bundleID: bundleID,
    dependencies: [
        .project(target: "Shared", path: .relativeToRoot("Projects/Shared")),
        .external(name: "Moya")
    ]
)
