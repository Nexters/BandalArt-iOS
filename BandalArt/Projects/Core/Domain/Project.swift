//
//  Projects.swift
//  BandalArtManifests
//
//  Created by Sang hun Lee on 2023/07/21.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Domain",
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
      target: "Util",
      path: .relativeToRoot("Projects/Shared/Util")
    )
  ]
)
