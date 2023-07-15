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
  name: "BandalArt",
  platform: .iOS,
  product: .app,
  dependencies: [
    .Projcet.Feature
  ],
  resources: ["Resources/**"],
  infoPlist: .file(path: "Support/Info.plist")
)
