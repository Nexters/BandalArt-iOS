//
//  Project.swift
//  BandalArtManifests
//
//  Created by Sang hun Lee on 2023/07/20.
//

import Foundation
import ProjectDescription
import UtilPlugin

let project = Project.makeModule(
  name: "CommonFeature",
  product: .staticFramework,
  packages: [],
  dependencies: [
    .project(
      target: "Network",
      path: .relativeToRoot("Projects/Core/Network")
    ),
    .project(
      target: "Database",
      path: .relativeToRoot("Projects/Core/Database")
    ),
    .project(
      target: "Components",
      path: .relativeToRoot("Projects/Shared/Components")
    ),
    .external(name: "CombineCocoa"),
    .external(name: "Lottie"),
    .external(name: "Kingfisher"),
    .external(name: "SnapKit")
  ]
)
