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

extension RoutingId {
    static let b = RoutingId(rawValue: "b")
}

protocol FlowBFlowDelegate: AnyObject {
    func routeTo(destination: Path)
    func enterA()
    func enterB()
    func enterC()
}

class FlowBFlowController: FlowController {
    private let storyboard = UIStoryboard(name: "FlowB", bundle: nil)
    private lazy var flowBViewCtrl: FlowBViewController = {
        let flowBViewCtrl = storyboard.instantiateViewController(withIdentifier: "FlowBViewController") as! FlowBViewController
        flowBViewCtrl.flowDelegate = self
        return flowBViewCtrl
    }()

    private let routingParameters: RoutingParameters?
    private let presentCompletion: ((Routable) -> Void)?
    private let animatePresentation: Bool

    init(routingParameters: RoutingParameters? = nil, animatePresentation: Bool = true, presentCompletion: ((Routable) -> Void)? = nil) {
        self.routingParameters = routingParameters
        self.animatePresentation = animatePresentation
        self.presentCompletion = presentCompletion
    }

    override func start(from presentingViewController: UIViewController) {
        Map.shared.didEnter(Node(identifier: .b, routable: self, parameters: routingParameters))
        presentingViewController.present(flowBViewCtrl, animated: animatePresentation) { [unowned self] in
            self.presentCompletion?(self)
        }
    }
}

extension FlowBFlowController: FlowBFlowDelegate {
    func enterA() {
        Router.enter(RoutingTable.Dynamic.a)
    }

    func enterB() {
        Router.enter(RoutingTable.Dynamic.b)
    }

    func enterC() {
        Router.enter(RoutingTable.Dynamic.c)
    }

    func routeTo(destination: Path) {
        Router.routeTo(destination, routingStrategy: Globals.routingStrategy, animated: Globals.animated)
    }
}

extension FlowBFlowController: Routable {
    func enter(_ nodeToEnter: Node, animated: Bool, completion: @escaping ((Routable) -> Void)) {
        switch nodeToEnter.identifier {
        case .a:
            let flowAFlowCtrl = FlowAFlowController(routingParameters: nodeToEnter.parameters, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: flowBViewCtrl)

        case .b:
            let flowBFlowCtrl = FlowBFlowController(routingParameters: nodeToEnter.parameters, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: flowBViewCtrl)

        case .c:
            let flowCFlowCtrl = FlowCFlowController(routingParameters: nodeToEnter.parameters, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowCFlowCtrl)
            flowCFlowCtrl.start(from: flowBViewCtrl)

        default:
            return
        }
    }

    func leave(_ nodeToLeave: Node, animated: Bool, completion: @escaping () -> Void) {
        flowBViewCtrl.dismiss(animated: animated) { [weak self] in
            guard let self = self else { return }

            Map.shared.didLeave(nodeToLeave)
            self.removeFromSuperFlowController()
            completion()
        }
    }

    func didEnterWithInfo(_ info: Any?) {
        guard let info = info as? String else { return }

        print(info)
    }
}
