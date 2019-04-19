//
//  SecondTabFlowController.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Portus
import UIKit

extension RoutingIdentifier {
    static let bookmarks = RoutingIdentifier(rawValue: "bookmarks")
}

class BookmarksTabFlowController: TabFlowController {
    private lazy var navigationCtrl: UINavigationController = {
        let navigationCtrl = UINavigationController(rootViewController: bookmarksTabViewCtrl)
        navigationCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        return navigationCtrl
    }()
    private lazy var bookmarksTabViewCtrl: BookmarksTabViewController = {
        let storyboard = UIStoryboard(name: "BookmarksTab", bundle: nil)
        let bookmarksTabViewCtrl = storyboard.instantiateViewController(withIdentifier: "BookmarksTabViewController") as! BookmarksTabViewController
        bookmarksTabViewCtrl.delegate = self
        return bookmarksTabViewCtrl
    }()

    override var tabViewController: UIViewController {
        return navigationCtrl
    }

    override func startIfNeeded() {
        super.startIfNeeded()
    }

    override func start() {
        super.start()
    }

    override func leave() {
        super.leave()
    }
}

// MARK: - SecondTabViewControllerDelegate
extension BookmarksTabFlowController: BookmarksTabViewControllerDelegate {}

// MARK: - Routable
extension BookmarksTabFlowController: Routable {
    var entry: RoutingEntry {
        return RoutingEntry(identifier: .bookmarks, routable: self)
    }
}

// MARK: - Enterable
extension BookmarksTabFlowController: Enterable {
    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .a:
            let flowAFlowCtrl = FlowAFlowController(
                context: entry.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: bookmarksTabViewCtrl)

        case .b:
            let flowBFlowCtrl = FlowBFlowController(
                context: entry.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: bookmarksTabViewCtrl)

        case .c:
            let flowCFlowCtrl = FlowCFlowController(
                context: entry.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowCFlowCtrl)
            flowCFlowCtrl.start(from: bookmarksTabViewCtrl)

        default:
            return
        }
    }
}
