//
//  Projects.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/18.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
   name: "BandalArt",
   platform: .iOS,
   product: .app,
   dependencies: [
       .project(
        target: "Feature",
        path: .relativeToRoot("Projects/Feature")
       ),
       .project(
         target: "Shared",
         path: .relativeToRoot("Projects/Shared")
       )
   ],
   resources: ["Resources/**"],
   infoPlist: .file(path: "Support/Info.plist")
)
