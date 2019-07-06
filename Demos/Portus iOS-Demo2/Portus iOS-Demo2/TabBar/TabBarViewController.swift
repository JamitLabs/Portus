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
    private lazy var firstTabController: FirstTabViewController = {
        let viewController = FirstTabViewController()
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        return viewController
    }()

    private lazy var secondTabController: SecondTabViewController = {
        let viewController = UIStoryboard(name: "SecondTabViewController", bundle: nil)
            .instantiateViewController(withIdentifier: "SecondTabViewController") as! SecondTabViewController
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        return viewController
    }()

    private lazy var thirdTabController: ThirdTabViewController = {
        let viewController = ThirdTabViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        return viewController
    }()

    private lazy var firstTabNavController = UINavigationController(rootViewController: firstTabController)
    private lazy var secondTabNavController = UINavigationController(rootViewController: secondTabController)
    private lazy var thirdTabNavController = UINavigationController(rootViewController: thirdTabController)

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        viewControllers = [firstTabNavController, secondTabNavController, thirdTabNavController]

        RoutingTree.default.didEnterNode(withEntry: entry)
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            RoutingMenu.showMenu()
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard
            let topViewController = (viewController as? UINavigationController)?.topViewController
        else {
            return true
        }

        switch topViewController {
        case is FirstTabViewController:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: firstTabController.entry)

        case is SecondTabViewController:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: secondTabController.entry)

        case is ThirdTabViewController:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: thirdTabController.entry)

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
        case .firstTab:
            selectedViewController = firstTabNavController
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: firstTabController.entry)
            animated ? DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion(true) } : completion(true)

        case .secondTab:
            selectedViewController = secondTabNavController
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: secondTabController.entry)
            animated ? DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion(true) } : completion(true)

        case .thirdTab:
            selectedViewController = thirdTabNavController
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: thirdTabController.entry)
            animated ? DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion(true) } : completion(true)

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
                entries: [firstTabController.entry, secondTabController.entry, thirdTabController.entry],
                activeEntry: firstTabController.entry
            )
        )
    }
}

