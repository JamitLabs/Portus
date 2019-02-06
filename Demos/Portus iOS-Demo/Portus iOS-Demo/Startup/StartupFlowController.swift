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

extension RoutingIdentifiers {
    static let root: String = "Root"
}

class StartupFlowController: InitialFlowController {
    private lazy var navigationCtrl: UINavigationController = {
        let navigationCtrl = UINavigationController(rootViewController: startupViewCtrl)
        return navigationCtrl
    }()

    private lazy var startupViewCtrl: StartupViewController = {
        let storyboard = UIStoryboard(name: "Startup", bundle: nil)
        let startupViewCtrl = storyboard.instantiateViewController(withIdentifier: "StartupViewController") as! StartupViewController
        startupViewCtrl.flowDelegate = self
        return startupViewCtrl
    }()

    // MARK: - Methods
    override func start(from window: UIWindow) {
        window.rootViewController = navigationCtrl
        Map.shared.didEnter(self)
    }
}

// MARK: - StartupFlowDelegate
extension StartupFlowController: StartupFlowDelegate {
    func flowAButtonTapped() {
        let flowAFlowCtrl = FlowAFlowController()
        add(subFlowController: flowAFlowCtrl)
        flowAFlowCtrl.start(from: navigationCtrl)
    }

    func flowBButtonTapped() {
        let flowBFlowCtrl = FlowBFlowController()
        add(subFlowController: flowBFlowCtrl)
        flowBFlowCtrl.start(from: navigationCtrl)
    }
}

extension StartupFlowController: Routable {
    static var routingId: RoutingIdentifier {
        return "Root"
    }

    func enter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool, completion: @escaping (Routable) -> Void) {
        switch routingIdentifier {
        case RoutingIdentifiers.A:
            let flowAFlowCtrl = FlowAFlowController(presentCompletion: completion, animatePresentation: true)
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: navigationCtrl)

        case RoutingIdentifiers.B:
            let flowBFlowCtrl = FlowBFlowController(presentCompletion: completion, animatePresentation: true)
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: navigationCtrl)

        default:
            return
        }
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        fatalError("The root not is not leavable!")
    }
}
