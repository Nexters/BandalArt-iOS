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
       .project(
        target: "RootFeature",
        path: .relativeToRoot("Projects/Feature/Root")
       ),
       .project(
         target: "Data",
         path: .relativeToRoot("Projects/Core/Data")
       ),
       .project(
         target: "Util",
         path: .relativeToRoot("Projects/Shared/Util")
       )
   ],
   resources: ["Resources/**"],
   infoPlist: .file(path: "Support/Info.plist")
)
