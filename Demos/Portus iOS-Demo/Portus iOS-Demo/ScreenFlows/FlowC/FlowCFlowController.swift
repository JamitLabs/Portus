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
    var entry: RoutingEntry {
        return RoutingEntry(identifier: .c, context: context, routable: self)
    }

    private let storyboard = UIStoryboard(name: "FlowC", bundle: nil)
    private lazy var flowCViewCtrl: FlowCViewController = {
        let flowCViewCtrl = storyboard.instantiateViewController(withIdentifier: "FlowCViewController") as! FlowCViewController
        flowCViewCtrl.flowDelegate = self
        return flowCViewCtrl
    }()

    private let context: RoutingContext?
    private let presentCompletion: ((Routable) -> Void)?
    private let animatePresentation: Bool

    init(context: RoutingContext? = nil, animatePresentation: Bool = true, presentCompletion: ((Routable) -> Void)? = nil) {
        self.context = context
        self.animatePresentation = animatePresentation
        self.presentCompletion = presentCompletion
    }

    override func start(from presentingViewController: UIViewController) {
        RoutingTree.default.didEnterNode(with: entry)
        presentingViewController.present(flowCViewCtrl, animated: animatePresentation) { [unowned self] in
            self.presentCompletion?(self)
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

    func routeTo(destination: Path) {
        Router.default.route(to: destination, animated: Globals.animated)
    }
}

// MARK: - Enterable
extension FlowCFlowController: Enterable {
    static func canEnter(node: RoutingEntry) -> Bool {
        switch node.identifier {
        case .a, .b, .c:
            return true

        default:
            return false
        }
    }
    func enter(node: RoutingEntry, animated: Bool, completion: @escaping ((Routable) -> Void)) {
        switch node.identifier {
        case .a:
            let flowAFlowCtrl = FlowAFlowController(context: node.context, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: flowCViewCtrl)

        case .b:
            let flowBFlowCtrl = FlowBFlowController(context: node.context, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: flowCViewCtrl)

        case .c:
            let flowCFlowCtrl = FlowCFlowController(context: node.context, animatePresentation: animated, presentCompletion: completion)
            add(subFlowController: flowCFlowCtrl)
            flowCFlowCtrl.start(from: flowCViewCtrl)

        default:
            return
        }
    }
}

// MARK: - Leavable
extension FlowCFlowController: Leavable {
    func canLeave(node: RoutingEntry) -> Bool {
        switch node.identifier {
        case .c:
            return true

        default:
            return false
        }
    }

    func leave(node: RoutingEntry, animated: Bool, completion: @escaping () -> Void) {
        switch node.identifier {
        case .c:
            flowCViewCtrl.dismiss(animated: animated) { [weak self] in
                guard let self = self else { return }

                RoutingTree.default.didLeaveNode(with: node)
                self.removeFromSuperFlowController()
                completion()
            }

        default:
            return
        }
    }
}
