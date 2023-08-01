//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/21.
//

import Foundation
import ProjectDescription
import UtilPlugin

let project = Project.makeModule(
    name: "OnBoardingFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.HomeFeature,
        .Project.Feature.CommonFeature
    ]
)
