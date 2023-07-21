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
        platform: Platform,
        bundleID: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return self.project(
            name: name,
            product: .app,
            platform: platform,
            bundleID: bundleID,
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
        dependencies: [TargetDependency] = [],
        package: [Package] = []
    ) -> Project {
        return self.project(
            name: name,
            product: .framework,
            platform: platform,
            bundleID: bundleID,
            dependencies: dependencies,
            package: package
        )
    }
    
    public static func project(
        name: String,
        product: Product,
        platform: Platform,
        bundleID: String,
        dependencies: [TargetDependency] = [],
        infoPlist: [String: InfoPlist.Value] = [:],
        targets: [Target] = [],
        package: [Package] = []
    ) -> Project {
        var targetList = [
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
        targetList.append(contentsOf: targets)
        
        return Project(
            name: name,
            targets: targetList,
            schemes: [
              Scheme(
                name: "\(name)-Debug",
                shared: true,
                buildAction: BuildAction(targets: ["\(name)"])
              ),
              Scheme(
                name: "\(name)-Release",
                shared: true,
                buildAction: BuildAction(targets: ["\(name)"])
              )
            ]
        )
    }
}

