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

extension RoutingIdentifiers {
    static let B: RoutingIdentifier = "B"
    static let containedVC: RoutingIdentifier = "NO_NAME_ViewController"
}

protocol FlowBFlowDelegate: class {
    func flowAButtonTapped()
    func flowBButtonTapped()
}

class FlowBFlowController: FlowController {
    private let storyboard = UIStoryboard(name: "FlowB", bundle: nil)
    private lazy var flowBViewCtrl: FlowBViewController = {
        let flowBViewCtrl = storyboard.instantiateViewController(withIdentifier: "FlowBViewController") as! FlowBViewController
        return flowBViewCtrl
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
        presentingViewController.present(flowBViewCtrl, animated: animatePresentation) {
            self.presentCompletion(self)
        }
    }
}

extension FlowBFlowController: FlowBFlowDelegate {
    func flowAButtonTapped() {
        let flowAFlowCtrl = FlowAFlowController()
        add(subFlowController: flowAFlowCtrl)
        flowAFlowCtrl.start(from: flowBViewCtrl)
    }

    func flowBButtonTapped() {
        let flowBFlowCtrl = FlowBFlowController()
        add(subFlowController: flowBFlowCtrl)
        flowBFlowCtrl.start(from: flowBViewCtrl)
    }
}

extension FlowBFlowController: Routable {
    static var routingId: RoutingIdentifier { return "B" }

    func enter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool, completion: @escaping (Routable) -> Void) {
        switch routingIdentifier {
        case RoutingIdentifiers.A:
            let flowAFlowCtrl = FlowAFlowController(presentCompletion: completion, animatePresentation: true)
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: flowBViewCtrl)

        case RoutingIdentifiers.containedVC:
            // switch context to contained VC
            break

        default:
            return
        }
    }

    func leave(animated: Bool, completion: @escaping () -> Void) {
        flowBViewCtrl.dismiss(animated: animated) { [weak self] in
            guard let self = self else { return }
            Map.shared.didLeave(self)
            self.removeFromSuperFlowController()
            completion()
        }
    }
}
