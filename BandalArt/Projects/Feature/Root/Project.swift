//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/19.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "RootFeature",
  product: .staticFramework,
  dependencies: [
    .project(
      target: "OnBoardingFeature",
      path: .relativeToRoot("Projects/Feature/OnBoarding")
    ),
    .project(
      target: "MainFeature",
      path: .relativeToRoot("Projects/Feature/Main")
    )
  ]
)
