//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/19.
//

import Foundation
import ProjectDescription
import UtilPlugin

let project = Project.makeModule(
  name: "Network",
  product: .staticFramework,
  packages: [
    
  ],
  dependencies: [
    .project(
      target: "Util",
      path: .relativeToRoot("Projects/Shared/Util")
    ),
    .external(name: "Moya")
  ]
)
