//
//  SplashViewController.swift
//  BandalArt
//
//  Created by Youngmin Kim on 2023/08/15.
//  Copyright © 2023 otani. All rights reserved.
//

import UIKit
import HomeFeature
import Lottie

final class SplashViewController: UIViewController {
    
    let animationView = LottieAnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let animation = LottieAnimation.named("Splash")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        view.addSubview(animationView)

        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 350),
            animationView.heightAnchor.constraint(equalToConstant: 350)
        ])

        animationView.play { (finished) in
            if finished {
                // 애니메이션이 끝나면 다음 화면으로 이동
                self.navigateToMainScreen()
            }
        }
    }
    
    func navigateToMainScreen() {
        
        let vc = HomeViewController(viewModel: HomeViewModel())

        let appearance = UINavigationBarAppearance()
        // set back image
        appearance.setBackIndicatorImage(UIImage(named: "chevron.left"), transitionMaskImage: UIImage(named: "chevron.left"))
        appearance.backgroundColor = .systemBackground

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
        
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else {
            return
        }
        delegate.window?.rootViewController = nav
    }
}

