//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Youngmin Kim on 2023/07/13.
//

import ProjectDescription
import ProjectDescriptionHelpers

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Core"
private let bundleID = "com.bandal.art.sample"
private let iOSTargetVersion = "13.0"

let project = Project.app(
    name: projectName,
    product: .staticFramework,
    bundleID: bundleID,
    platform: .iOS,
    dependencies: [
        .project(target: "Shared", path: .relativeToManifest("../Shared"))
    ]
)
