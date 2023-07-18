//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/19.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "HomeFeature",
    product: .staticFramework,
    dependencies: [
        .project(
          target: "Core",
          path: .relativeToRoot("Projects/Core")
        ),
        .project(
          target: "Shared",
          path: .relativeToRoot("Projects/Shared")
        )
    ],
    resources: ["Resources/**"]
)
