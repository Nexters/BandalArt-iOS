//
//  Project.swift
//  BandalArtManifests
//
//  Created by Sang hun Lee on 2023/07/21.
//

import Foundation
import ProjectDescription
import UtilPlugin

let project = Project.makeModule(
  name: "Data",
  product: .staticFramework,
  dependencies: [
    .project(
      target: "Domain",
      path: .relativeToRoot("Projects/Core/Domain")
    ),
    .project(
      target: "Util",
      path: .relativeToRoot("Projects/Shared/Util")
    )
  ]
)
