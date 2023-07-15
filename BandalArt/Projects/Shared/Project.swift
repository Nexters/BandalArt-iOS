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
  name: "Shared",
  product: .staticFramework,
  dependencies: [
    .project(
      target: "ThirdParty",
      path: .relativeToRoot("Projects/ThirdParty")
    )
  ],
  resources: ["Resources/**"]
)

