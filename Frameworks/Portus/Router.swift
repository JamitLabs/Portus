//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import UIKit

public class Router {
    /// A default Router using the default RoutingTree
    public static let `default`: Router = Router(routingTree: RoutingTree.default)

    private let routingTree: RoutingTree

    init(routingTree: RoutingTree) {
        self.routingTree = routingTree
    }

    /// Enters a dynamic destination defined in the RoutingTable, i.e., a destination that is independent of the current
    /// context and can be entered from anywhere.
    ///
    /// - Parameters:
    ///     - entry:        The destination to route to, defined as dynamic entry within the `RoutingTable`.
    ///     - animated:     Set the value of this property to `true` if intermediate transition steps to the
    ///                     destination should be animated
    ///     - completion:   Called when the given destination is entered successfully or when the operation failed,
    public func enter(dynamicDestination entry: RoutingEntry, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        execute(routingInstruction: .enter(entry: entry, animated: animated)) { success in
            completion?(success)
        }
    }

    /// Routes to static destinations defined in the RoutingTable, i.e., destinations that depend on the current context
    ///
    /// - Parameters:
    ///     - destination:  The destination to route to, defined as static entry within the `RoutingTable`.
    ///     - animated:     Set the value of this property to `true` if intermediate transition steps to the
    ///                     destination should be animated
    ///     - completion:   Called when routing succeded or failed with an error,
    ///                     e.g., `RoutingError.destinationNotReachable`
    public func routeTo(
        staticDestination: StaticRoutingDestination,
        animated: Bool = true,
        completion: ((Result<Void, RoutingError>) -> Void)? = nil
    ) {
        RoutingAlgorithm.computeRoutingInstructions(
            in: RoutingTree(from: RoutingTree.default),
            to: staticDestination
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

            enterable.enterNode(with: entry, animated: animated) { success in
                completion(success)
            }

        case let .leave(entry, animated):
            guard let leavable = currentRoutable as? Leavable else { return completion(false) }

            leavable.leaveNode(with: entry, animated: animated) { success in
                completion(success)
            }

        case let .switchTo(entry, origin, animated):
            guard let switchable = origin.routable as? Switchable else { return completion(false) }

            switchable.switchToNode(with: entry, animated: animated) { success in
                completion(success)
            }
        }
    }
}
