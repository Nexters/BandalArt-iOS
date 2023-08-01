//
//  Project.swift
//  BandalArtManifests
//
//  Created by Sang hun Lee on 2023/07/20.
//

import Foundation
import ProjectDescription
import UtilPlugin

let project = Project.makeModule(
    name: "SettingFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.CommonFeature
    ]
)
