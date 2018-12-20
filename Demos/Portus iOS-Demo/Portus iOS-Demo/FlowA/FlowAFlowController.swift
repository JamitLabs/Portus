//
//  FlowA.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit
import Imperio
import Portus

class FlowAFlowController: FlowController {
    private let storyboard = UIStoryboard(name: "FlowA", bundle: nil)
    private lazy var flowAViewCtrl: FlowAViewController = {
        let flowAViewCtrl = storyboard.instantiateViewController(withIdentifier: "FlowAViewController") as! FlowAViewController
        return flowAViewCtrl
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
        presentingViewController.present(flowAViewCtrl, animated: animatePresentation) {
            self.presentCompletion(self.flowAViewCtrl)
        }
    }
}

extension FlowAFlowController: PortKeyEnterable {
    var visibleViewController: UIViewController {
        return flowAViewCtrl
    }

    static var routingId: String {
        return "A"
    }

    static func enter(from presentingViewController: UIViewController, info: Any?, animated: Bool, completion: @escaping (UIViewController) -> Void) {
        FlowAFlowController(presentCompletion: completion, animatePresentation: animated).start(from: presentingViewController)
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        MaraudersMap.shared.didLeave(self)
        flowAViewCtrl.dismiss(animated: animated, completion: completion)
    }
}
