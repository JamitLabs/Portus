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

extension RoutingID {
    static let c = RoutingID(rawValue: "c")
}

protocol FlowCFlowDelegate: AnyObject {
    func routeTo(destination: RoutingDestination)
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

    private let context: RoutingContext?
    private let presentCompletion: ((Bool) -> Void)?
    private let animatePresentation: Bool

    init(context: RoutingContext? = nil, animatePresentation: Bool = true, presentCompletion: ((Bool) -> Void)? = nil) {
        self.context = context
        self.animatePresentation = animatePresentation
        self.presentCompletion = presentCompletion
    }

    override func start(from presentingViewController: UIViewController) {
        RoutingTree.default.didEnterNode(withEntry: entry)
        presentingViewController.present(flowCViewCtrl, animated: animatePresentation) { [unowned self] in
            self.presentCompletion?(true)
        }
    }
}

extension FlowCFlowController: FlowCFlowDelegate {
    func enterA() {
        Router.default.enter(node: RoutingTable.Dynamic.a)
    }

    func enterB() {
        Router.default.enter(node: RoutingTable.Dynamic.b)
    }

    func enterC() {
        Router.default.enter(node: RoutingTable.Dynamic.c)
    }

    func routeTo(destination: RoutingDestination) {
        Router.default.route(to: destination, animated: Globals.animated)
    }
}

// MARK: - Routable
extension FlowCFlowController {
    var entry: RoutingEntry {
        return RoutingEntry(identifier: .c, context: context, routable: self)
    }
}

// MARK: - Enterable
extension FlowCFlowController: Enterable {
    static func canEnter(node: RoutingEntry) -> Bool {
        return node.identifier ~= .a || node.identifier ~= .b || node.identifier ~= .c
    }

    func enter(node: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch node.identifier {
        case .a:
            let flowAFlowCtrl = FlowAFlowController(
                context: node.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: flowCViewCtrl)

        case .b:
            let flowBFlowCtrl = FlowBFlowController(
                context: node.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: flowCViewCtrl)

        case .c:
            let flowCFlowCtrl = FlowCFlowController(
                context: node.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowCFlowCtrl)
            flowCFlowCtrl.start(from: flowCViewCtrl)

        default:
            completion(false)
        }
    }
}

// MARK: - Leavable
extension FlowCFlowController: Leavable {
    func canLeave(node: RoutingEntry) -> Bool {
        return node.identifier ~= .c
    }

    func leave(node: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void) {
        switch node.identifier {
        case .c:
            flowCViewCtrl.dismiss(animated: animated) { [weak self] in
                guard let self = self else { return }

                RoutingTree.default.didLeaveNode(with: node)
                self.removeFromSuperFlowController()
                completion(true)
            }

        default:
            completion(false)
        }
    }
}
