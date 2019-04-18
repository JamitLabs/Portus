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

extension RoutingId {
    static let root = RoutingId(rawValue: "Root")
}

protocol TabBarFlowDelegate: AnyObject {}

class TabBarFlowController: InitialFlowController {
    var entry: RoutingEntry {
        return RoutingEntry(identifier: .root, routable: self)
    }

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
        colorListFlowCtrl.flowDelegate = self
        return colorListFlowCtrl
    }()

    private lazy var bookmarksTabFlowCtrl: BookmarksTabFlowController = {
        let bookmarksTabFlowCtrl = BookmarksTabFlowController()
        bookmarksTabFlowCtrl.flowDelegate = self
        return bookmarksTabFlowCtrl
    }()

    private func tabBarFlowController(for tabViewCtrl: UIViewController?) -> TabFlowController? {
        guard let tabViewCtrl = tabViewCtrl else { return nil }

        return tabBarTabFlowControllers.first(where: { $0.tabViewController == tabViewCtrl })
    }

    private var selectedViewController: UIViewController! {
        didSet {
            RoutingTree.default.didSwitchToNode(
                with: (tabBarFlowController(for: selectedViewController) as! Routable).entry,
                fromNodeWith: entry
            )
            tabBarController.selectedViewController = selectedViewController
        }
    }

    override func start(from window: UIWindow) {
        RoutingTree.default.didEnterSwitchableNode(
            with: entry,
            entriesOfManagedNodes: [
                colorListFlowCtrl.entry,
                bookmarksTabFlowCtrl.entry
            ],
            entryOfActiveNode: colorListFlowCtrl.entry
        )
        window.rootViewController = tabBarController
        tabBarTabFlowControllers = [colorListFlowCtrl, bookmarksTabFlowCtrl]
    }
}

// MARK: - FlowDelegate
extension TabBarFlowController: TabBarFlowDelegate {

}

extension TabBarFlowController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        selectedViewController = viewController
        return false
    }
}

// MARK: - Switchable
extension TabBarFlowController: Switchable {
    func canSwitchTo(node: RoutingEntry) -> Bool {
        return node.identifier ~= .colorList || node.identifier ~= .bookmarks
    }

    func switchTo(node: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch node.identifier {
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
