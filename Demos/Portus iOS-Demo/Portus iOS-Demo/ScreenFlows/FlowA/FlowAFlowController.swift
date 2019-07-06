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
    static let a = RoutingIdentifier(rawValue: "a")
}

protocol FlowAFlowDelegate: AnyObject {
    func routeTo(staticDestination: StaticRoutingDestination)
    func enter(dynamicDestination: DynamicRoutingDestination)
}

class FlowAFlowController: FlowController {
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
        RoutingTree.default.didEnterNode(withEntry: entry)
        presentingViewController.present(flowAViewCtrl, animated: animatePresentation) { [unowned self] in
            self.presentCompletion?(true)
        }
    }
}

extension FlowAFlowController: FlowAFlowDelegate {
    func enter(dynamicDestination: DynamicRoutingDestination) {
        Router.default.enter(dynamicDestination: dynamicDestination)
    }

    func routeTo(staticDestination: StaticRoutingDestination) {
        Router.default.routeTo(staticDestination: staticDestination, animated: Globals.animated)
    }
}

// MARK: - Routable
extension FlowAFlowController: Routable {
    var entry: RoutingEntry {
        return RoutingEntry(identifier: .a, context: context, routable: self)
    }
}

// MARK: - Enterable
extension FlowAFlowController: Enterable {
    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .a:
            let flowAFlowCtrl = FlowAFlowController(
                context: entry.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowAFlowCtrl)
            flowAFlowCtrl.start(from: flowAViewCtrl)

        case .b:
            let flowBFlowCtrl = FlowBFlowController(
                context: entry.context,
                animatePresentation: animated,
                presentCompletion: completion
            )
            add(subFlowController: flowBFlowCtrl)
            flowBFlowCtrl.start(from: flowAViewCtrl)

        case .c:
            let flowCFlowCtrl = FlowCFlowController(
                context: entry.context,
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
    func canLeaveNode(with entry: RoutingEntry) -> Bool {
        return entry.identifier ~= .a
    }

    func leaveNode(with entry: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void) {
        switch entry.identifier {
        case .a:
            flowAViewCtrl.dismiss(animated: animated) { [weak self] in
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
