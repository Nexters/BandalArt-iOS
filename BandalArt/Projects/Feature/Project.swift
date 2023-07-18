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
  name: "Feature",
  product: .staticFramework,
  dependencies: [
    .project(
      target: "HomeFeature",
      path: .relativeToRoot("Projects/Feature/Home")
    ),
    .project(
      target: "SettingFeature",
      path: .relativeToRoot("Projects/Feature/Setting")
    ),
    .project(
      target: "BottomSheetFeature",
      path: .relativeToRoot("Projects/Feature/BottomSheet")
    )
  ],
  resources: ["Resources/**"]
)
