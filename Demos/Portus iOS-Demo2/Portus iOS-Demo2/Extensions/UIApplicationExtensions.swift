//
//  UIApplicationExtensions.swift
//  Portus iOS-Demo2
//
//  Created by Andreas Link on 24.04.19.
//  Copyright © 2019 Andreas Link. All rights reserved.
//

import UIKit

extension UIApplication {
    class func topViewController(
        controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
    ) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }

        return controller
    }
}
