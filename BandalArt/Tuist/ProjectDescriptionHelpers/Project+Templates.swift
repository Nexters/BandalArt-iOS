import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    
    public static func target(
        name: String,
        product: Product,
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = [],
        scripts: [TargetScript] = [],
        baseSettings: ProjectDescription.SettingsDictionary = [:],
        coreDataModels: [CoreDataModel] = []
    ) -> Target {
        return Target(
            name: name,
            platform: .iOS,
            product: product,
            bundleId: "com.mint.ex.\(name.lowercased())",
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            scripts: scripts,
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": "$(inherited)"
                ].merging(baseSettings) { $1 },
                configurations: [],
                defaultSettings: .recommended(excluding: [
                    "TARGETED_DEVICE_FAMILY",
                    "SWIFT_ACTIVE_COMPLATION_CONDITIONS",
                ])
            ),
            coreDataModels: coreDataModels
        )
    }
}

extension Project {
    
    public static func app(
        name: String,
        product: Product,
        bundleID: String,
        platform: Platform,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return self.project(
            name: name,
            product: product,
            bundleID: bundleID,
            platform: platform,
            dependencies: dependencies,
            infoPlist: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1"
            ]
        )
    }
    
    public static func framework(
        name: String,
        platform: Platform,
        bundleID: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return self.project(
            name: name,
            product: .framework,
            bundleID: bundleID,
            platform: platform,
            dependencies: dependencies
        )
    }
    
    public static func project(
        name: String,
        product: Product,
        bundleID: String,
        platform: Platform,
        dependencies: [TargetDependency] = [],
        infoPlist: [String: InfoPlist.Value] = [:]
    ) -> Project {
        return Project(
            name: name,
            targets: [
                Target(
                    name: name,
                    platform: platform,
                    product: product,
                    bundleId: bundleID,
                    infoPlist: .extendingDefault(with: infoPlist),
                    sources: ["Sources/**"],
                    resources: [],
                    dependencies: dependencies
                ),
                Target(
                    name: "\(name)Tests",
                    platform: platform,
                    product: .unitTests,
                    bundleId: bundleID,
                    infoPlist: .default,
                    sources: "Tests/**",
                    dependencies: [
                        .target(name: "\(name)")
                    ]
                )
            ]
        )
    }
}

