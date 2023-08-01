//
//  Projects.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/18.
//

import Foundation
import ProjectDescription
import UtilPlugin

let project = Project.makeModule(
    name: "BandalArt",
    platform: .iOS,
    product: .app,
    dependencies: [
        .Project.Core.Network,
        .Project.Feature.OnBoardingFeature,
        .Project.Feature.HomeFeature,
        .Project.Shared.Components,
        .Project.Shared.Util,
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
)
