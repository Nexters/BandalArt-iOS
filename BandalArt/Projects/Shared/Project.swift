//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Youngmin Kim on 2023/07/13.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Shared"
private let bundleID = "com.bandal.art.sample"
private let iOSTargetVersion = "13.0"

let project = Project.framework(
    name: projectName,
    platform: .iOS,
    bundleID: bundleID,
    dependencies: [
    ]
)