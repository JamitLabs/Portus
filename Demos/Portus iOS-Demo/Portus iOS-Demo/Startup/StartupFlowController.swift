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
        window.makeKeyAndVisible()
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
