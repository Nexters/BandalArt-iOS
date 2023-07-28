//
//  Project.swift
//  Config
//
//  Created by Sang hun Lee on 2023/07/23.
//

import Foundation
import ProjectDescription
import UtilPlugin

let project = Project.makeModule(
  name: "Database",
  product: .staticFramework,
  packages: [],
  dependencies: [
    .project(
      target: "Util",
      path: .relativeToRoot("Projects/Shared/Util")
    )
  ]
)
