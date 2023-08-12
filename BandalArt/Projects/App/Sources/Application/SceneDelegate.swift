//
//  SceneDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/18.
//

import UIKit

import HomeFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let vc = HomeViewController(viewModel: HomeViewModel())

        let appearance = UINavigationBarAppearance()
        // set back image
        appearance.setBackIndicatorImage(UIImage(named: "chevron.left"), transitionMaskImage: UIImage(named: "chevron.left"))
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage(named: "shadow")

        // set appearance to one NavigationController
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.tintColor = .gray900
        nav.navigationItem.backButtonTitle = ""
        nav.navigationItem.backBarButtonItem?.title = ""

        // or you can config for all navigation bar
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
