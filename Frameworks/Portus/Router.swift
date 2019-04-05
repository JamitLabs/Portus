//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import UIKit

public enum Router {
    public static func enter(
        node: RoutingEntry,
        animated: Bool = true,
        info: Any? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard let currentEnterable = RoutingTree.shared.currentPath.last?.routable as? Enterable else {
            completion?(false)
            return
        }

        currentEnterable.enter(node: node, animated: animated) { _ in
            completion?(true)
        }
    }

    public static func route(
        to destination: Path,
        routingStrategy: RoutingStrategy = .minRouteToLeaf,
        animated: Bool = true,
        info: Any? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        let routingInstructions = RoutingAlgorithm.determineRoutingInstructions(
            toDestination: destination,
            withRoutingStrategy: routingStrategy
        )

        execute(routingInstructions: routingInstructions) { executionSuccessful in
            completion?(executionSuccessful)
        }
    }
}

extension Router {
    private static func execute(routingInstructions: RoutingInstructions, completion: @escaping (Bool) -> Void) {
        guard let nextInstruction = routingInstructions.first else { return completion(true) }

        execute(routingInstruction: nextInstruction) { executionSuccessful in
            guard executionSuccessful else { return completion(true) }

            execute(routingInstructions: Array(routingInstructions.dropFirst()), completion: completion)
        }
    }

    private static func execute(routingInstruction: RoutingInstruction, completion: @escaping (Bool) -> Void) {
        guard let currentRoutable = RoutingTree.shared.currentPath.last?.routable else { return completion(false) }

        switch routingInstruction {
        case let .enter(entry, animated):
            guard let enterable = currentRoutable as? Enterable else { return completion(false) }

            enterable.enter(node: entry, animated: animated) { routable in
                completion(true)
            }

        case let .leave(entry, animated):
            guard let leavable = currentRoutable as? Leavable else { return completion(false) }

            leavable.leave(node: entry, animated: animated) {
                completion(true)
            }

        case let .switchTo(entry, animated):
            guard let switchable = currentRoutable as? Switchable else { return completion(false) }

            switchable.switchTo(node: entry, animated: animated) { routable in
                completion(true)
            }
        }
    }
}
