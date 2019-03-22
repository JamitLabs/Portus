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
            tabBarFlowController(for: oldValue)?.leave()
            tabBarFlowController(for: selectedViewController)?.startIfNeeded()
            tabBarController.selectedViewController = selectedViewController
        }
    }

    // MARK: - Methods
    override func start(from window: UIWindow) {
        RoutingTree.shared.didEnter(RoutingEntry(identifier: .root, routable: self))
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

// MARK: - Routable
extension TabBarFlowController: Routable {
    func enter(node: RoutingEntry, animated: Bool, completion: @escaping ((Routable) -> Void)) {
        switch node.identifier {
        case .colorList:
            selectedViewController = colorListFlowCtrl.tabViewController
            completion(colorListFlowCtrl)

        case .bookmarks:
            selectedViewController = bookmarksTabFlowCtrl.tabViewController
            completion(bookmarksTabFlowCtrl)

        default:
            return
        }
    }
}
