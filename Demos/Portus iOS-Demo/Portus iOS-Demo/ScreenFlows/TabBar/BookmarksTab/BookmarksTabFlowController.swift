//
//  SecondTabFlowController.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Portus
import UIKit

extension RoutingId {
    static let bookmarks = RoutingId(rawValue: "bookmarks")
}

class BookmarksTabFlowController: TabFlowController {
    weak var flowDelegate: TabBarFlowDelegate?

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
        Map.shared.didEnter(Node(identifier: .bookmarks, routable: self))
        super.startIfNeeded()
    }

    override func start() {
        super.start()
    }

    override func leave() {
        Map.shared.didLeave(Node(identifier: .bookmarks, routable: self))
        super.leave()
    }
}

// MARK: - SecondTabViewControllerDelegate
extension BookmarksTabFlowController: BookmarksTabViewControllerDelegate {}

// MARK: - Routable
extension BookmarksTabFlowController: Routable {
    func leave(_ nodeToLeave: Node, animated: Bool, completion: @escaping () -> Void) {
        Map.shared.didLeave(nodeToLeave)
        completion()
    }

    func enter(_ nodeToEnter: Node, animated: Bool, completion: @escaping ((Routable) -> Void)) {
        switch nodeToEnter.identifier {
        case .a:
            let flowAFlowCtrl = FlowAFlowController(routingParameters: nodeToEnter.parameters, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: bookmarksTabViewCtrl)

        case .b:
            let flowBFlowCtrl = FlowBFlowController(routingParameters: nodeToEnter.parameters, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: bookmarksTabViewCtrl)

        case .c:
            let flowCFlowCtrl = FlowCFlowController(routingParameters: nodeToEnter.parameters, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowCFlowCtrl)
            flowCFlowCtrl.start(from: bookmarksTabViewCtrl)

        default:
            return
        }
    }
}
