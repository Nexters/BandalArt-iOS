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
  name: "Core",
  product: .staticFramework,
  dependencies: [
    .project(
      target: "Network",
      path: .relativeToRoot("Projects/Core/Network")
    ),
    .project(
      target: "UserDefaults",
      path: .relativeToRoot("Projects/Core/UserDefaults")
    ),
    .project(
      target: "Shared",
      path: .relativeToRoot("Projects/Shared")
    )
  ]
)
