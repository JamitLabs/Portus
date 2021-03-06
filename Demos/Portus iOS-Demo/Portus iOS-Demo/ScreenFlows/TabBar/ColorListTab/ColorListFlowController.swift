//
//  ColorListFlowController
//  Portus iOS-Demo
//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Portus
import UIKit

extension RoutingIdentifier {
    static let colorList = RoutingIdentifier(rawValue: "colorList")
    static let colorDetail = RoutingIdentifier(rawValue: "colorDetail")
}

class ColorListFlowController: TabFlowController {
    private var context: RoutingContext?
    private var colorDetailDismissCompletion: ((Bool) -> Void)?
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
        super.startIfNeeded()
    }

    override func start() {
        super.start()
    }

    override func leave() {
        super.leave()
    }

    private func showDetails(for color: UIColor, completion: ((Bool) -> Void)? = nil) {
        context = ["hex": color.hexString]
        colorDetailViewCtrl.viewModel = ColorDetailViewModel(color: color)
        CATransaction.begin()
        CATransaction.setCompletionBlock { [unowned self] in
            RoutingTree.default.didEnterNode(
                withEntry: RoutingEntry(identifier: .colorDetail, context: self.context, routable: self)
            )
            completion?(true)
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

// MARK: - ColorDetailViewControllerDelegate
extension ColorListFlowController: ColorDetailViewControllerDelegate {
    func actionButtonTriggered() {
        Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.bookmarks)
    }

    func viewDidDisappear(in viewController: ColorDetailViewController) {
        RoutingTree.default.didLeaveNode(
            with: RoutingEntry(identifier: .colorDetail, context: context, routable: self)
        )
        context = nil
        colorDetailDismissCompletion?(true)
        colorDetailDismissCompletion = nil
    }
}

// MARK: - Routable
extension ColorListFlowController: Routable {
    var entry: RoutingEntry {
        return RoutingEntry(identifier: .colorList, routable: self)
    }
}

// MARK: - Enterable
extension ColorListFlowController: Enterable {
    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .colorDetail:
            if let parameters = entry.context, let hexString = parameters["hex"] {
                showDetails(for: UIColor(hex: hexString), completion: completion)
            }

        default:
            completion(false)
        }
    }
}

// MARK: - Leavable
extension ColorListFlowController: Leavable {
    func canLeaveNode(with entry: RoutingEntry) -> Bool {
        return entry.identifier ~= .colorDetail
    }

    func leaveNode(with entry: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void) {
        switch entry.identifier {
        case .colorDetail:
            colorDetailDismissCompletion = completion
            navigationCtrl.popToRootViewController(animated: animated)

        default:
            completion(false)
        }
    }
}
