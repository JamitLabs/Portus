//
//  FlowControllerB.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit
import Imperio
import Portus

class FlowBFlowController: FlowController {
    private let storyboard = UIStoryboard(name: "FlowB", bundle: nil)
    private lazy var flowBViewCtrl: FlowBViewController = {
        let flowBViewCtrl = storyboard.instantiateViewController(withIdentifier: "FlowBViewController") as! FlowBViewController
        return flowBViewCtrl
    }()

    private let presentCompletion: (UIViewController) -> Void

    init(presentCompletion: @escaping (UIViewController) -> Void) {
        self.presentCompletion = presentCompletion
    }

    convenience override init() { self.init(presentCompletion: { _ in }) }

    override func start(from presentingViewController: UIViewController) {
        MaraudersMap.shared.didEnter(self)
        presentingViewController.present(flowBViewCtrl, animated: true) {
            self.presentCompletion(self.flowBViewCtrl)
        }
    }
}

extension FlowBFlowController: PortKeyEnterable {
    var visibleViewController: UIViewController {
        return flowBViewCtrl
    }

    static var routingId: String {
        return "B"
    }

    static func enter(from presentingViewController: UIViewController, info: Any?, animated: Bool, completion: @escaping (UIViewController) -> Void) {
        FlowBFlowController(presentCompletion: completion).start(from: presentingViewController)
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        MaraudersMap.shared.didLeave(self)
        flowBViewCtrl.dismiss(animated: animated, completion: completion)
    }
}
