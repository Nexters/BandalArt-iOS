//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/21.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "OnBoardingFeature",
    product: .staticFramework,
    dependencies: [
        .project(
          target: "CommonFeature",
          path: .relativeToRoot("Projects/Feature/Common")
        )
    ]
)
