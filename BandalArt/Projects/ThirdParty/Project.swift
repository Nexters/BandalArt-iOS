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
    name: "ThirdParty",
    product: .framework,
    packages: [
      .CombineCoCoa,
      .Moya,
      .SnapKit,
      .Lottie,
      // TODO: Firebase 관련 세팅 필요
    ],
    dependencies: [
      .SPM.CombineCoCoa,
      .SPM.Moya,
      .SPM.SnapKit,
      .SPM.Lottie,
    ]
)
