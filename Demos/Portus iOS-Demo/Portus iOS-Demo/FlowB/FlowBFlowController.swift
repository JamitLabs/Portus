//
//  FlowControllerB.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit
import Imperio

class FlowBFlowController: FlowController {

    // MARK: - Properties
    private let storyboard = UIStoryboard(name: "FlowB", bundle: nil)
    private lazy var flowBViewCtrl: FlowBViewController = {
        let flowBViewCtrl = storyboard.instantiateViewController(withIdentifier: "FlowBViewController") as! FlowBViewController
        return flowBViewCtrl
    }()

    override func start(from presentingViewController: UIViewController) {
        presentingViewController.present(flowBViewCtrl, animated: true)
    }
}
