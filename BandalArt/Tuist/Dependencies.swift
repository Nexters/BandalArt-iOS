//
//  Dependencies.swift
//  Config
//
//  Created by Youngmin Kim on 2023/07/21.
//


import ProjectDescription
import ProjectDescriptionHelpers

// in Dependencies.swift
let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .remote(
                url: "https://github.com/SnapKit/SnapKit.git",
                requirement: .exact("5.6.0")
            ),
            .remote(
                url: "https://github.com/CombineCommunity/CombineCocoa.git",
                requirement: .branch("main")
            ),
            .remote(
                url: "https://github.com/Moya/Moya.git",
                requirement: .exact("15.0.3")
            ),
            .remote(
                url: "https://github.com/airbnb/lottie-ios.git",
                requirement: .exact("4.2.0")
            )
        ],
        baseSettings: .settings(
            configurations: [
                .debug(name: .debug),
                .release(name: .release),
            ]
        ),
        targetSettings: [:]
    ),
    platforms: [.iOS]
)
