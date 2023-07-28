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
    name: "Components",
    product: .staticFramework,
    dependencies: [
      .project(
        target: "Util",
        path: .relativeToRoot("Projects/Shared/Util")
      )
    ],
    resources: []
)
