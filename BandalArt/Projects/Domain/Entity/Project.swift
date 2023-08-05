//
//  Project.swift
//  Config
//
//  Created by Youngmin Kim on 2023/08/01.
//

import Foundation
import ProjectDescription
import UtilPlugin

let project = Project.makeModule(
    name: "Entity",
    product: .staticFramework,
    dependencies: [
        .Project.Shared.Util
    ]
)
