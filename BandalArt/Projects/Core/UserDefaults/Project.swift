//
//  Porject.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/19.
//

import ProjectDescription
import UtilPlugin

let project = Project.makeModule(
  name: "UserDefaults",
  product: .staticFramework,
  dependencies: [
    .project(
      target: "Util",
      path: .relativeToRoot("Projects/Shared/Util")
    )
  ]
)
