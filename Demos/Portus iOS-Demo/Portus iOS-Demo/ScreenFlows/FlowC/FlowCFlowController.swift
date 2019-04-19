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

extension RoutingIdentifier {
    static let c = RoutingIdentifier(rawValue: "c")
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
        Router.default.enterNode(withEntry: RoutingTable.Dynamic.a)
    }

    func enterB() {
        Router.default.enterNode(withEntry: RoutingTable.Dynamic.b)
    }

    func enterC() {
        Router.default.enterNode(withEntry: RoutingTable.Dynamic.c)
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
    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .a:
            let flowAFlowCtrl = FlowAFlowController(
                context: entry.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: flowCViewCtrl)

        case .b:
            let flowBFlowCtrl = FlowBFlowController(
                context: entry.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: flowCViewCtrl)

        case .c:
            let flowCFlowCtrl = FlowCFlowController(
                context: entry.context,
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
    func canLeaveNode(with entry: RoutingEntry) -> Bool {
        return entry.identifier ~= .c
    }

    func leaveNode(with entry: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void) {
        switch entry.identifier {
        case .c:
            flowCViewCtrl.dismiss(animated: animated) { [weak self] in
                guard let self = self else { return }

                RoutingTree.default.didLeaveNode(with: entry)
                self.removeFromSuperFlowController()
                completion(true)
            }

        default:
            completion(false)
        }
    }
}
