//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import UIKit

public enum Router {
    public static func enter(
        _ node: RoutingEntry,
        animated: Bool = true,
        info: Any? = nil,
        completion: (() -> Void)? = nil
    ) {
        guard let currentRoutable = RoutingTree.shared.currentPath.last?.routable else { completion?(); return }

        currentRoutable.enter(node, animated: animated) { _ in
            guard let currentRoutable = RoutingTree.shared.currentPath.last?.routable else { completion?(); return }

            currentRoutable.didEnterWithInfo(info)
            completion?()
        }
    }

    public static func routeTo(
        _ destination: Path,
        routingStrategy: RoutingStrategy = .minRouteToLeaf,
        animated: Bool = true,
        info: Any? = nil,
        completion: (() -> Void)? = nil
    ) {
        let routingInstructions = RoutingAlgorithm.determineRoutingInstructions(toDestination: destination, withRoutingStrategy: routingStrategy)

        recursivelyLeave(nodesToLeave: routingInstructions.nodesToLeave.reversed(), animated: animated) {
            recursivelyEnter(nodesToEnter: routingInstructions.nodesToEnter, animated: animated) {
                guard let currentRoutable = RoutingTree.shared.currentPath.last?.routable else { completion?(); return }

                currentRoutable.didEnterWithInfo(info)
                completion?()
            }
        }
    }
}

extension Router {
    private static func recursivelyLeave(nodesToLeave: [RoutingEntry], animated: Bool, completion: (() -> Void)? = nil) {
        guard
            let nodeToLeave = nodesToLeave.first,
            let firstRoutableToLeave = nodeToLeave.routable
        else {
            completion?()
            return
        }

        firstRoutableToLeave.leave(nodeToLeave, animated: animated) {
            recursivelyLeave(nodesToLeave: Array(nodesToLeave.dropFirst()), animated: animated, completion: completion)
        }
    }

    private static func recursivelyEnter(nodesToEnter: [RoutingEntry], animated: Bool, completion: (() -> Void)? = nil) {
        guard
            let firstNodeToEnter = nodesToEnter.first,
            let currentRoutable = RoutingTree.shared.currentPath.last?.routable
        else {
            completion?()
            return
        }

        currentRoutable.enter(firstNodeToEnter, animated: animated) { _ in
            recursivelyEnter(nodesToEnter: Array(nodesToEnter.dropFirst()), animated: animated, completion: completion)
        }
    }
}
