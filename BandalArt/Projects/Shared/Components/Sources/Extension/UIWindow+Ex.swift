//
//  UIWindow+Ex.swift
//  Components
//
//  Created by Sang hun Lee on 2023/08/15.
//  Copyright © 2023 otani. All rights reserved.
//

import UIKit

public extension UIWindow {
    var visibleViewController: UIViewController? {
        return visibleViewControllerFrom(viewController: rootViewController)
    }

    static var firstRootViewController: UIViewController? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .first(where: { $0.isKeyWindow })?.rootViewController
    }

    func visibleViewControllerFrom(viewController: UIViewController? = firstRootViewController) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return self.visibleViewControllerFrom(viewController: navigationController.visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return self.visibleViewControllerFrom(viewController: tabBarController.selectedViewController)
        } else {
            if let presentedViewController = viewController?.presentedViewController {
                return visibleViewControllerFrom(viewController: presentedViewController)
            } else {
                return viewController
            }
        }
    }
}
