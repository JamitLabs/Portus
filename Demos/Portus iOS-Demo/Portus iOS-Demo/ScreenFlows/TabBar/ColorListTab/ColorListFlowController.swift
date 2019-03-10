//
//  ColorListFlowController
//  Portus iOS-Demo
//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Portus
import UIKit

extension RoutingId {
    static let colorList = RoutingId(rawValue: "colorList")
    static let colorDetail = RoutingId(rawValue: "colorDetail")
}

class ColorListFlowController: TabFlowController {
    weak var flowDelegate: TabBarFlowDelegate?

    private var colorDetailRoutingParameters: RoutingParameters?
    private lazy var navigationCtrl: UINavigationController = {
        let navigationCtrl = UINavigationController(rootViewController: colorListViewCtrl)
        navigationCtrl.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        return navigationCtrl
    }()

    private lazy var colorListViewCtrl: ColorListViewController = {
        let storyboard = UIStoryboard(name: "ColorList", bundle: nil)
        let colorListViewCtrl = storyboard.instantiateViewController(withIdentifier: "ColorListViewController") as! ColorListViewController
        colorListViewCtrl.delegate = self
        return colorListViewCtrl
    }()

    private lazy var colorDetailViewCtrl: ColorDetailViewController = {
        let storyboard = UIStoryboard(name: "ColorDetail", bundle: nil)
        let colorDetailViewCtrl = storyboard.instantiateViewController(withIdentifier: "ColorDetailViewController") as! ColorDetailViewController
        colorDetailViewCtrl.delegate = self
        return colorDetailViewCtrl
    }()

    override var tabViewController: UIViewController {
        return navigationCtrl
    }

    override func startIfNeeded() {
        Map.shared.didEnter(Node(identifier: .colorList, routable: self))
        super.startIfNeeded()
    }

    override func start() {
        super.start()
    }

    override func leave() {
        Map.shared.didLeave(Node(identifier: .colorList, routable: self))
        super.leave()
    }

    private func showDetails(for color: UIColor, completion: (() -> Void)? = nil) {
        colorDetailRoutingParameters = ["hex": color.hexString]
        colorDetailViewCtrl.viewModel = ColorDetailViewModel(color: color)
        CATransaction.begin()
        CATransaction.setCompletionBlock { [unowned self] in
            Map.shared.didEnter(Node(identifier: .colorDetail, routable: self, parameters: self.colorDetailRoutingParameters))
            completion?()
        }
        navigationCtrl.pushViewController(colorDetailViewCtrl, animated: true)
        CATransaction.commit()
    }
}

// MARK: - ColorListViewControllerDelegate
extension ColorListFlowController: ColorListViewControllerDelegate {
    func viewController(_ viewController: ColorListViewController, didSelect color: UIColor) {
        showDetails(for: color)
    }
}

extension ColorListFlowController: ColorDetailViewControllerDelegate {
    func actionButtonTriggered() {
        Router.routeTo(RoutingTable.Static.bookmarks)
    }

    func viewDidDisappear(in viewController: ColorDetailViewController) {
        Map.shared.didLeave(Node(identifier: .colorDetail, routable: self, parameters: colorDetailRoutingParameters))
        colorDetailRoutingParameters = nil
    }
}

// MARK: - Routable
extension ColorListFlowController: Routable {
    func leave(_ nodeToLeave: Node, animated: Bool, completion: @escaping () -> Void) {
        switch nodeToLeave.identifier {
        case .colorDetail:
            CATransaction.begin()
            CATransaction.setCompletionBlock { Map.shared.didLeave(nodeToLeave); completion() }
            navigationCtrl.popToRootViewController(animated: animated)
            CATransaction.commit()

        default:
            Map.shared.didLeave(nodeToLeave)
            completion()
        }
    }

    func enter(_ nodeToEnter: Node, animated: Bool, completion: @escaping ((Routable) -> Void)) {
        switch nodeToEnter.identifier {
        case .colorDetail:
            if let parameters = nodeToEnter.parameters, let hexString = parameters["hex"] {
                showDetails(for: UIColor(hex: hexString))
            }
        default:
            return
        }
    }
}
