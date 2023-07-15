//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/13.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Feature",
  product: .staticFramework,
  dependencies: [
    .project(
      target: "Domain",
      path: .relativeToRoot("Projects/Domain")
    ),
    .project(
      target: "Shared",
      path: .relativeToRoot("Projects/Shared")
    )
  ],
  resources: ["Resources/**"]
)
