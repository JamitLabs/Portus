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

extension RoutingId {
    static let c = RoutingId(rawValue: "c")
}

protocol FlowCFlowDelegate: AnyObject {
    func routeTo(destination: Path)
    func enterA()
    func enterB()
    func enterC()
}

class FlowCFlowController: FlowController {
    private let storyboard = UIStoryboard(name: "FlowC", bundle: nil)
    private lazy var flowCViewCtrl: FlowCViewController = {
        let flowCViewCtrl = storyboard.instantiateViewController(withIdentifier: "FlowCViewController") as! FlowCViewController
        flowCViewCtrl.flowDelegate = self
        return flowCViewCtrl
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
        Map.shared.didEnter(Node(identifier: .c, routable: self, parameters: routingParameters))
        presentingViewController.present(flowCViewCtrl, animated: animatePresentation) { [unowned self] in
            self.presentCompletion?(self)
        }
    }
}

extension FlowCFlowController: FlowCFlowDelegate {
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

extension FlowCFlowController: Routable {
    func enter(_ nodeToEnter: Node, animated: Bool, completion: @escaping ((Routable) -> Void)) {
        switch nodeToEnter.identifier {
        case .a:
            let flowAFlowCtrl = FlowAFlowController(routingParameters: nodeToEnter.parameters, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: flowCViewCtrl)

        case .b:
            let flowBFlowCtrl = FlowBFlowController(routingParameters: nodeToEnter.parameters, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: flowCViewCtrl)

        case .c:
            let flowCFlowCtrl = FlowCFlowController(routingParameters: nodeToEnter.parameters, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowCFlowCtrl)
            flowCFlowCtrl.start(from: flowCViewCtrl)

        default:
            return
        }
    }

    func leave(_ nodeToLeave: Node, animated: Bool, completion: @escaping () -> Void) {
        flowCViewCtrl.dismiss(animated: animated) { [weak self] in
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
