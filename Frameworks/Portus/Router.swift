//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import UIKit

public class Router {
    public static let `default`: Router = Router(routingTree: RoutingTree.default)

    private let routingTree: RoutingTree

    init(routingTree: RoutingTree) {
        self.routingTree = routingTree
    }

    public func enter(node: RoutingEntry, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentEnterable = routingTree.root?.activeLeaf()?.entry.routable as? Enterable else {
            completion?(false)
            return
        }

        currentEnterable.enter(node: node, animated: animated) { success in
            completion?(success)
        }
    }

    public func route(
        to destination: RoutingDestination,
        animated: Bool = true,
        completion: ((Result<Void, RoutingError>) -> Void)? = nil
    ) {
        RoutingAlgorithm.computeRoutingInstructions(
            in: RoutingTree(from: RoutingTree.default),
            to: destination
        ) { [weak self] result in
            switch result {
            case let .success(routingInstructions):
                guard let self = self else { return }

                self.execute(routingInstructions: routingInstructions) { executionSuccessful in
                    completion?(executionSuccessful ? .success(()) : .failure(.destinationNotReachable))
                }

            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
}

// MARK: - Routing Instruction Simulation
extension Router {
    internal func simulate(routingInstructions: RoutingInstructions, completion: @escaping () -> Void) {
        guard let firstRoutingInstruction = routingInstructions.first else { return completion() }

        simulate(routingInstruction: firstRoutingInstruction) { [weak self] in
            guard let self = self else { return }

            self.simulate(routingInstructions: Array(routingInstructions.dropFirst()), completion: completion)
        }
    }

    private func simulate(routingInstruction: RoutingInstruction, completion: @escaping () -> Void) {
        switch routingInstruction {
        case let .enter(entry, _):
            routingTree.didEnterNode(withEntry: entry)
            completion()

        case let .leave(entry, _):
            routingTree.didLeaveNode(with: entry)
            completion()

        case let .switchTo(targetEntry, entry, _):
            routingTree.switchNode(withEntry: entry, didSwitchToNodeWithEntry: targetEntry)
            completion()
        }
    }
}

// MARK: - Routing Instruction Execution
extension Router {
    private func execute(routingInstructions: RoutingInstructions, completion: @escaping (Bool) -> Void) {
        guard let nextInstruction = routingInstructions.first else { return completion(true) }

        execute(routingInstruction: nextInstruction) { [weak self] executionSuccessful in
            guard let self = self, executionSuccessful else { return completion(false) }

            self.execute(routingInstructions: Array(routingInstructions.dropFirst()), completion: completion)
        }
    }

    private func execute(routingInstruction: RoutingInstruction, completion: @escaping (Bool) -> Void) {
        guard
            let currentRoutable = routingTree.root?.activeLeaf()?.entry.routable
        else {
            return completion(false)
        }

        switch routingInstruction {
        case let .enter(entry, animated):
            guard let enterable = currentRoutable as? Enterable else { return completion(false) }

            enterable.enter(node: entry, animated: animated) { success in
                completion(success)
            }

        case let .leave(entry, animated):
            guard let leavable = currentRoutable as? Leavable else { return completion(false) }

            leavable.leave(node: entry, animated: animated) { success in
                completion(success)
            }

        case let .switchTo(entry, origin, animated):
            guard let switchable = origin.routable as? Switchable else { return completion(false) }

            switchable.switchTo(node: entry, animated: animated) { success in
                completion(success)
            }
        }
    }
}
