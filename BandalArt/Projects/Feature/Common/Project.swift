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
    name: "CommonFeature",
    product: .staticFramework,
    packages: [],
    dependencies: [
        .Project.Domain.UseCase,
        .Project.Domain.Entity,
        .Project.Shared.Components,
        .external(name: "CombineCocoa"),
        .external(name: "Lottie"),
        .external(name: "Kingfisher"),
        .external(name: "SnapKit")
    ]
)
