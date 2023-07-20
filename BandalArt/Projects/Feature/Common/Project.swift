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
  name: "CommonFeature",
  product: .staticFramework,
  dependencies: [
    .project(
      target: "Data",
      path: .relativeToRoot("Projects/Core/Data")
    ),
    .project(
      target: "Components",
      path: .relativeToRoot("Projects/Shared/Components")
    )
  ]
)
