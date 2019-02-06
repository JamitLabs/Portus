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

extension RoutingIdentifiers {
    static let A: RoutingIdentifier = "A"
}

protocol FlowAFlowDelegate: class {
    func flowAButtonTapped()
    func flowBButtonTapped()
}

class FlowAFlowController: FlowController {
    private let storyboard = UIStoryboard(name: "FlowA", bundle: nil)
    private lazy var flowAViewCtrl: FlowAViewController = {
        let flowAViewCtrl = storyboard.instantiateViewController(withIdentifier: "FlowAViewController") as! FlowAViewController
        return flowAViewCtrl
    }()

    private let presentCompletion: (Routable) -> Void
    private let animatePresentation: Bool

    init(presentCompletion: @escaping (Routable) -> Void, animatePresentation: Bool) {
        self.presentCompletion = presentCompletion
        self.animatePresentation = animatePresentation
    }

    convenience override init() { self.init(presentCompletion: { _ in }, animatePresentation: true) }

    override func start(from presentingViewController: UIViewController) {
        Map.shared.didEnter(self)
        presentingViewController.present(flowAViewCtrl, animated: animatePresentation) {
            self.presentCompletion(self)
        }
    }
}

extension FlowAFlowController: FlowAFlowDelegate {
    func flowAButtonTapped() {
        let flowAFlowCtrl = FlowAFlowController()
        add(subFlowController: flowAFlowCtrl)
        flowAFlowCtrl.start(from: flowAViewCtrl)
    }

    func flowBButtonTapped() {
        let flowBFlowCtrl = FlowBFlowController()
        add(subFlowController: flowBFlowCtrl)
        flowBFlowCtrl.start(from: flowAViewCtrl)
    }
}

extension FlowAFlowController: Routable {
    static var routingId: RoutingIdentifier { return "A" }

    func enter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool, completion: @escaping (Routable) -> Void) {
        switch routingIdentifier {
        case RoutingIdentifiers.B:
            let flowBFlowCtrl = FlowBFlowController(presentCompletion: completion, animatePresentation: true)
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: flowAViewCtrl)

        default:
            return
        }
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        flowAViewCtrl.dismiss(animated: animated) { [weak self] in
            guard let self = self else { return }
            Map.shared.didLeave(self)
            self.removeFromSuperFlowController()
            completion()
        }
    }
}
