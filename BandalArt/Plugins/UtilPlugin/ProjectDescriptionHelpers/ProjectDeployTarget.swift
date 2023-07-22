//
//  ProjectDeployTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/21.
//

import Foundation
import ProjectDescription

public enum ProjectDeployTarget: String {
    case dev = "DEV"
    case prod = "PROD"
    
    public var configurationName: ConfigurationName {
        ConfigurationName.configuration(self.rawValue)
    }
}
