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
  name: "Network",
  product: .staticFramework,
  dependencies: [
    .project(
      target: "Shared",
      path: .relativeToRoot("Projects/Shared")
    )
  ]
)
