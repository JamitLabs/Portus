//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit

public enum Router {
    public enum AnimationExtent: Int {
        /// No route entrance will be animated.
        case notAtAll

        /// Only the destination entrance will be animated.
        case singleAnimation

        /// All enterings along the route will be animated.
        case eachStep
    }

    public enum RoutingStrategy: Int {
        /// Routing will always start from the root – resulting in exactly the specified path.
        case alwaysFromRoot

        /// Routing will always start from the root, but reuse any already open paths from the beginning – resulting in exactly the specified path.
        case maxReusageFromRoot

        /// Routing will always start from the leaf, only leaving until any match is found – only the last k (>1) entries are like the specified path.
        case minRouteToLeaf
    }

    public static func changeContext(_ target: Context, routingStrategy: RoutingStrategy = .minRouteToLeaf, info: Any? = nil) {
        let (nodesToLeave, identifiersToEnter) = pathToDestination(targetContext: target, routingStrategy: routingStrategy)

        recursivelyLeave(nodesToLeave: nodesToLeave.reversed()) {
            recursivelyEnter(identifiersToEnter: identifiersToEnter)
        }
    }

    private static func recursivelyLeave(nodesToLeave: [Routable], completion: @escaping () -> Void) {
        guard let first = nodesToLeave.first else { return completion() }

        first.leave(animated: true) {
            recursivelyLeave(nodesToLeave: Array(nodesToLeave.dropFirst()), completion: completion)
        }
    }

    private static func recursivelyEnter(identifiersToEnter: [RoutingIdentifier]) {
        guard let identifierToEnter = identifiersToEnter.first else { return }
        guard let currentNode = Map.shared.currentPath.last else { return }

        currentNode.enter(routingIdentifier: identifierToEnter, info: nil, animated: true) { routable in
            recursivelyEnter(identifiersToEnter: Array(identifiersToEnter.dropFirst()))
        }
    }

    internal static func pathToDestination(targetContext: Context, routingStrategy: RoutingStrategy) -> ([Routable], Context) {
        switch routingStrategy {
        case .alwaysFromRoot:
            return (Array(Map.shared.currentPath.dropFirst()), Array(targetContext.dropFirst()))

        case .maxReusageFromRoot:
            var nodesToLeave = Map.shared.currentPath
            var identifiersToEnter: Context = targetContext

            for nodeToLeave in nodesToLeave {
                guard let firstIdentifierToEnter = identifiersToEnter.first, type(of: nodeToLeave).routingId == firstIdentifierToEnter else {
                    return (nodesToLeave, identifiersToEnter)
                }

                nodesToLeave.removeFirst()
                identifiersToEnter.removeFirst()
            }

            return (nodesToLeave, identifiersToEnter)

        case .minRouteToLeaf:
            var identifiersToEnter: [RoutingIdentifier] = []

            for identifier in targetContext.reversed() {
                if let lastIndex = Map.shared.currentPath.lastIndex(
                    where: { type(of: $0).routingId == identifier }
                ) {
                    let nodesToLeave: [Routable] = Array(Map.shared.currentPath.suffix(from: lastIndex + 1))
                    return (nodesToLeave, identifiersToEnter)
                } else {
                    identifiersToEnter.insert(identifier, at: 0)
                }
            }

            return (Map.shared.currentPath, targetContext)
        }
    }
}
