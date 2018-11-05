//
//  StartUpFlowController.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit
import Portus
import Imperio

protocol StartupFlowDelegate: class {
    func flowAButtonTapped()
    func flowBButtonTapped()
}

class StartupFlowController: InitialFlowController {
    // MARK: - Properties
    var routingID: String = "A"
    var parent: Routable?
    var children: [Routable] = []

    private let storyboard = UIStoryboard(name: "Startup", bundle: nil)
    private lazy var navigationCtrl: UINavigationController = {
        let navigationCtrl = UINavigationController(rootViewController: viewController)
        return navigationCtrl
    }()

    private lazy var viewController: StartupViewController = {
        let storyboViewCtrl = storyboard.instantiateViewController(withIdentifier: "StartupViewController") as! StartupViewController
        storyboViewCtrl.flowDelegate = self
        return storyboViewCtrl
    }()

    // MARK: - Initializers
    override init() {
        DelegatesManager.shared.router = self
        super.init()
    }

    override func start(from window: UIWindow) {
        navigationCtrl = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationCtrl
    }
}

// MARK: - Routable
extension StartupFlowController: Routable {
    func dismiss(animated: Bool, completion: @escaping () -> Void) {
        return
    }

    func open(_ routable: Routable, animated: Bool, completion: @escaping () -> Void) {
        switch routable.routingID {
        case "A":
            let flowAFlowCtrl = FlowControllerA()
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: navigationCtrl)

        case "B":
            let flowBFlowCtrl = FlowControllerB()
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: navigationCtrl)

        default:
            return
        }
    }
}

// MARK: - StartupFlowDelegate
extension StartupFlowController: StartupFlowDelegate {
    func flowAButtonTapped() {
        let origin: Path =
        let destination: Path =
        DelegatesManager.shared.router?.route(from: origin, to: destination)
    }

    func flowBButtonTapped() {
        <#code#>
    }
}
