//
//  Project.swift
//  BandalArtManifests
//
//  Created by Sang hun Lee on 2023/07/20.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "SettingFeature",
    product: .staticFramework,
    dependencies: [
      .project(
        target: "CommonFeature",
        path: .relativeToRoot("Projects/Feature/Common")
      )
    ]
)
