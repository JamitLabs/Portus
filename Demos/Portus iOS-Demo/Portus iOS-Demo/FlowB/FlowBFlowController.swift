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
    private let animatePresentation: Bool

    init(presentCompletion: @escaping (UIViewController) -> Void, animatePresentation: Bool) {
        self.presentCompletion = presentCompletion
        self.animatePresentation = animatePresentation
    }

    convenience override init() { self.init(presentCompletion: { _ in }, animatePresentation: true) }

    override func start(from presentingViewController: UIViewController) {
        MaraudersMap.shared.didEnter(self)
        presentingViewController.present(flowBViewCtrl, animated: animatePresentation) {
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
        FlowBFlowController(presentCompletion: completion, animatePresentation: animated).start(from: presentingViewController)
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        MaraudersMap.shared.didLeave(self)
        flowBViewCtrl.dismiss(animated: animated, completion: completion)
    }
}
