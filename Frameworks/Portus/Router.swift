//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import UIKit

/// Enables routing to either static or dynamic routing destinations. The `default` instance uses the default
/// `RoutingTree`
public class Router {
    /// A default Router using the default RoutingTree
    public static let `default`: Router = Router(routingTree: RoutingTree.default)

    /// The routing tree used by the router
    private let routingTree: RoutingTree

    /// Initializes a router instance for a given routing tree
    ///
    /// - Parameter routingTree: The routing tree
    init(routingTree: RoutingTree) {
        self.routingTree = routingTree
    }

    /// Enters a dynamic destination defined in the RoutingTable, i.e., a destination that is independent of the current
    /// context and can be entered from anywhere.
    ///
    /// - Parameters:
    ///     - dynamicDestination: The destination to route to, defined as dynamic entry within the `RoutingTable`.
    ///     - animated: Set the value of this property to `true` if intermediate transition steps to the
    ///                 destination should be animated
    ///     - completion: Called when the given destination is entered successfully or when the operation failed.
    public func enter(dynamicDestination entry: RoutingEntry, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        execute(routingInstruction: .enter(entry: entry), animated: animated) { success in
            completion?(success)
        }
    }

    /// Routes to static destinations defined in the RoutingTable, i.e., destinations that depend on the current context
    ///
    /// - Parameters:
    ///     - staticDestination: The destination to route to, defined as static entry within the `RoutingTable`.
    ///     - animated: Set the value of this property to `true` if intermediate transition steps to the
    ///                 destination should be animated
    ///     - executedInstructions: A list of routing instructions which have already been executed
    ///     - completion: Called when routing succeded with all executed routing instructions or failed
    ///       with an error, e.g., `.destinationNotReachable`
    public func routeTo(
        staticDestination: StaticRoutingDestination,
        animated: Bool = true,
        executedInstructions: RoutingInstructions = [],
        completion: ((Result<RoutingInstructions, RoutingError>) -> Void)? = nil
    ) {
        RoutingAlgorithm.computeNextRoutingInstructions(to: staticDestination) { [weak self] result in
            switch result {
            case let .success(routingInstructions):
                guard let self = self else { return }

                guard !routingInstructions.isEmpty else {
                    completion?(.success((executedInstructions)))
                    return
                }

                self.execute(routingInstructions: routingInstructions, animated: animated) { [unowned self] success in
                    guard success else {
                        completion?(.failure(.destinationNotReachable))
                        return
                    }

                    self.routeTo(
                        staticDestination: staticDestination,
                        animated: animated,
                        executedInstructions: executedInstructions + routingInstructions,
                        completion: completion
                    )
                }

            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
}

// MARK: - Routing Instruction Execution
extension Router {
    /// Recursively executes a given list of routing instructions on the routing tree
    ///
    /// - Parameters:
    ///     - routingInstructions: The routing instructions to execute.
    ///     - animated: `True` if the execution of the routing instructions should be animated
    ///     - completion: Called when the execution of the given instructions succeeded or failed
    private func execute(
        routingInstructions: RoutingInstructions,
        animated: Bool,
        completion: @escaping (Bool) -> Void
    ) {
        guard let nextInstruction = routingInstructions.first else { return completion(true) }

        execute(routingInstruction: nextInstruction, animated: animated) { [weak self] executionSuccessful in
            guard let self = self, executionSuccessful else { return completion(false) }

            self.execute(
                routingInstructions: Array(routingInstructions.dropFirst()),
                animated: animated,
                completion: completion
            )
        }
    }

    /// Executes a given routing instruction on the routing tree
    ///
    /// - Parameters:
    ///     - routingInstruction: The routing instruction to execute.
    ///     - animated: `True` if the execution of the routing instruction should be animated
    ///     - completion: Called when the execution of the given instruction either succeeded or failed
    private func execute(
        routingInstruction: RoutingInstruction,
        animated: Bool,
        completion: @escaping (Bool) -> Void
    ) {
        switch routingInstruction {
        case let .enter(entry):
            guard
                let currentRoutable = routingTree.root?.activeLeaf()?.entry.routable,
                let enterable = currentRoutable as? Enterable
            else {
                return completion(false)
            }

            enterable.enterNode(with: entry, animated: animated) { success in
                completion(success)
            }

        case let .leave(entry):
            guard let leavable = entry.routable as? Leavable else { return completion(false) }

            leavable.leaveNode(with: entry, animated: animated) { success in
                completion(success)
            }

        case let .switchTo(entry, origin):
            guard let switchable = origin.routable as? Switchable else { return completion(false) }

            switchable.switchToNode(with: entry, animated: animated) { success in
                completion(success)
            }
        }
    }
}
