//
//  StartUpFlowController.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit
import Imperio
import Portus

extension RoutingIdentifier {
    static let root = RoutingIdentifier(rawValue: "Root")
}

class TabBarFlowController: InitialFlowController {
    private var tabBarTabFlowControllers: [TabFlowController] = [] {
        didSet {
            guard tabBarTabFlowControllers != oldValue else { return }

            tabBarController.viewControllers = tabBarTabFlowControllers.map { $0.tabViewController }
            tabBarController.viewControllers?.forEach { $0.loadViewIfNeeded() }
        }
    }

    private lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        return tabBarController
    }()

    private lazy var colorListFlowCtrl: ColorListFlowController = {
        let colorListFlowCtrl = ColorListFlowController()
        return colorListFlowCtrl
    }()

    private lazy var bookmarksTabFlowCtrl: BookmarksTabFlowController = {
        let bookmarksTabFlowCtrl = BookmarksTabFlowController()
        return bookmarksTabFlowCtrl
    }()

    private func tabBarFlowController(for tabViewCtrl: UIViewController?) -> TabFlowController? {
        guard let tabViewCtrl = tabViewCtrl else { return nil }

        return tabBarTabFlowControllers.first(where: { $0.tabViewController == tabViewCtrl })
    }

    private var selectedViewController: UIViewController! {
        didSet {
            RoutingTree.default.switchNode(
                withEntry: entry,
                didSwitchToNodeWithEntry: (tabBarFlowController(for: selectedViewController) as! Routable).entry
            )
            tabBarController.selectedViewController = selectedViewController
        }
    }

    override func start(from window: UIWindow) {
        RoutingTree.default.didEnterSwitchNode(
            withEntry: entry,
            andManagedNodeEntries: [
                colorListFlowCtrl.entry,
                bookmarksTabFlowCtrl.entry
            ],
            andActiveNodeEntry: colorListFlowCtrl.entry
        )
        window.rootViewController = tabBarController
        tabBarTabFlowControllers = [colorListFlowCtrl, bookmarksTabFlowCtrl]
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarFlowController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        selectedViewController = viewController
        return false
    }
}

// MARK: - Routable
extension TabBarFlowController: Routable {
    var entry: RoutingEntry {
        return RoutingEntry(identifier: .root, routable: self)
    }
}

// MARK: - Switchable
extension TabBarFlowController: Switchable {
    func canSwitchToNode(with entry: RoutingEntry) -> Bool {
        return entry.identifier ~= .colorList || entry.identifier ~= .bookmarks
    }

    func switchToNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .colorList:
            selectedViewController = colorListFlowCtrl.tabViewController
            completion(true)

        case .bookmarks:
            selectedViewController = bookmarksTabFlowCtrl.tabViewController
            completion(true)

        default:
            completion(false)
        }
    }
}
