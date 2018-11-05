//
//  FlowA.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit
import Imperio

class FlowControllerA: FlowController {

    // MARK: - Properties
    private let storyboard = UIStoryboard(name: "FlowA", bundle: nil)
    private lazy var flowAViewCtrl: FlowAViewController = {
        let flowAViewCtrl = storyboard.instantiateViewController(withIdentifier: "FlowAViewController") as! FlowAViewController
        return flowAViewCtrl
    }()

    override func start(from presentingViewController: UIViewController) {
        presentingViewController.present(flowAViewCtrl, animated: true)
    }
}
