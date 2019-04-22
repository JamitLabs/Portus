//
//  ViewController.swift
//  Portus iOS-Demo2
//
//  Created by Andreas Link on 22.04.19.
//  Copyright © 2019 Andreas Link. All rights reserved.
//

import Portus
import UIKit

extension RoutingIdentifier {
    static let root = RoutingIdentifier(rawValue: "root")
}

class TabBarViewController: UITabBarController {
    private lazy var firstTabViewController: FirstTabViewController = {
        let viewController = FirstTabViewController()
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        return viewController
    }()

    private lazy var secondTabViewController: SecondTabViewController = {
        let viewController = UIStoryboard(name: "SecondTabViewController", bundle: nil).instantiateViewController(withIdentifier: "SecondTabViewController") as! SecondTabViewController
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        return viewController
    }()

    private lazy var thirdTabViewController: ThirdTabViewController = {
        let viewController = ThirdTabViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        return viewController
    }()

    private lazy var firstTabNavigationController = UINavigationController(rootViewController: firstTabViewController)
    private lazy var secondTabNavigationController = UINavigationController(rootViewController: secondTabViewController)
    private lazy var thirdTabNavigationController = UINavigationController(rootViewController: thirdTabViewController)

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        viewControllers = [firstTabNavigationController, secondTabNavigationController, thirdTabNavigationController]

        RoutingTree.default.didEnterNode(withEntry: entry)
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let topViewController = (viewController as? UINavigationController)?.topViewController else { return true }
        switch topViewController {
        case is FirstTabViewController:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: firstTabViewController.entry)

        case is SecondTabViewController:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: secondTabViewController.entry)

        case is ThirdTabViewController:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: thirdTabViewController.entry)

        default:
            return true
        }

        return true
    }
}

// MARK: - Switchable
extension TabBarViewController: Switchable {
    func switchToNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .bookmarks:
            selectedViewController = firstTabNavigationController
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: firstTabViewController.entry)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion(true) }

        case .secondTab:
            selectedViewController = secondTabNavigationController
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: secondTabViewController.entry)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion(true) }

        case .favorites:
            selectedViewController = thirdTabNavigationController
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: thirdTabViewController.entry)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion(true) }

        default:
            completion(false)
        }
    }
}

// MARK: - Routable
extension TabBarViewController: Routable {
    var entry: RoutingEntry {
        return RoutingEntry(
            identifier: .root,
            routable: self,
            managedEntries: RoutingEntry.ManagedEntries(
                entries: [firstTabViewController.entry, secondTabViewController.entry, thirdTabViewController.entry],
                activeEntry: firstTabViewController.entry
            )
        )
    }
}

