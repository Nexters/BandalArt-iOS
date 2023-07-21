//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Youngmin Kim on 2023/07/13.
//

import ProjectDescription
import ProjectDescriptionHelpers


private let projectName = "Database"
private let bundleID = "com.bandal.art.core.database"
private let iOSTargetVersion = "15.0"

let project = Project.framework(
    name: projectName,
    platform: .iOS,
    bundleID: bundleID,
    dependencies: [
        .project(target: "Shared", path: .relativeToRoot("Projects/Shared"))
    ]
)
