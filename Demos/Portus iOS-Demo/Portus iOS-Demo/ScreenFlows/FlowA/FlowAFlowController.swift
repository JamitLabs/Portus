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
    static let a = RoutingId(rawValue: "a")
}

protocol FlowAFlowDelegate: AnyObject {
    func routeTo(destination: Path)
    func enterA()
    func enterB()
    func enterC()
}

class FlowAFlowController: FlowController {
    var entry: RoutingEntry {
        return RoutingEntry(identifier: .a, context: context, routable: self)
    }

    private let storyboard = UIStoryboard(name: "FlowA", bundle: nil)
    private lazy var flowAViewCtrl: FlowAViewController = {
        let flowAViewCtrl = storyboard.instantiateViewController(withIdentifier: "FlowAViewController") as! FlowAViewController
        flowAViewCtrl.flowDelegate = self
        return flowAViewCtrl
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
        RoutingTree.default.didEnterNode(with: entry)
        presentingViewController.present(flowAViewCtrl, animated: animatePresentation) { [unowned self] in
            self.presentCompletion?(true)
        }
    }
}

extension FlowAFlowController: FlowAFlowDelegate {
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
extension FlowAFlowController: Enterable {
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
            flowAFlowCtrl.start(from: flowAViewCtrl)

        case .b:
            let flowBFlowCtrl = FlowBFlowController(
                context: node.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: flowAViewCtrl)

        case .c:
            let flowCFlowCtrl = FlowCFlowController(
                context: node.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowCFlowCtrl)
            flowCFlowCtrl.start(from: flowAViewCtrl)

        default:
            completion(false)
        }
    }
}

// MARK: - Leavable
extension FlowAFlowController: Leavable {
    func canLeave(node: RoutingEntry) -> Bool {
        return node.identifier ~= .a
    }

    func leave(node: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void) {
        switch node.identifier {
        case .a:
            flowAViewCtrl.dismiss(animated: animated) { [weak self] in
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
