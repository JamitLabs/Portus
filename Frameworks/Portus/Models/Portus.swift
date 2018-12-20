//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

enum Portus {
    enum AnimationExtent {
        /// No route entrance will be animated.
        case notAtAll

        /// Only the destination entrance will be animated.
        case destinationOnly

        /// All enterings along the route will be animated.
        case fully
    }

    enum RoutingStrategy {
        /// Routing will always start from the root – resulting in exactly the specified path.
        case alwaysFromRoot

        /// Routing will always start from the root, but reuse any already open paths from the beginning – resulting in exactly the specified path.
        case maxReusageFromRoot

        /// Routing will always start from the leaf, only leaving until any match is found – only the last k (>1) entries are like the specified path.
        case minRouteToLeaf
    }

    static func use(portKey: PortKey, animationExtent: AnimationExtent = .destinationOnly, routingStrategy: RoutingStrategy = .minRouteToLeaf) {
        let (routeToLeave, routeToEnter) = pathToDestination(portKey: portKey, routingStrategy: routingStrategy)

        for toLeave in routeToLeave.reversed() {
            let animated: Bool = animationExtent == .fully || (animationExtent == .destinationOnly && routeToEnter.isEmpty && routeToLeave.last! === toLeave)

            let group = DispatchGroup()
            group.enter()
            print("Leaving \(String(describing: type(of: toLeave))).")
            toLeave.leave(animated: animated) { group.leave() }
            //            group.wait() // TODO: this will probably block the main thread, fix or delete this comment
        }

        for (routingId, enteringData) in routeToEnter {
            print("Entering \(routingId).")
            // TODO: not yet implemented
        }
    }

    internal static func pathToDestination(portKey: PortKey, routingStrategy: RoutingStrategy) -> ([PortKeyLeavable], Route) {
        switch routingStrategy {
        case .alwaysFromRoot:
            return (MaraudersMap.shared.currentPath, portKey.route)

        case .maxReusageFromRoot:
            guard var routeToLeave = MaraudersMap.shared.currentPath as? [PortKeyEnterable] else { return (MaraudersMap.shared.currentPath, portKey.route) }
            var routeToEnter: Route = portKey.route

            for (routingId, _) in portKey.route {
                guard let firstEntered = routeToLeave.first, type(of: firstEntered).routingId == routingId else { return (routeToLeave, routeToEnter) }

                routeToLeave.removeFirst()
                routeToEnter.removeFirst()
            }

            return (routeToLeave, routeToEnter)

        case .minRouteToLeaf:
            var routeToEnter: Route = []

            for routeElement in portKey.route.reversed() {
                if let lastIndex = MaraudersMap.shared.currentPath.lastIndex(where: { $0 is PortKeyEnterable && type(of: $0 as! PortKeyEnterable).routingId == routeElement.routingId }) {
                    let routeToLeave: [PortKeyLeavable] = Array(MaraudersMap.shared.currentPath.suffix(from: lastIndex + 1))
                    return (routeToLeave, routeToEnter)
                } else {
                    routeToEnter.append(routeElement)
                }
            }

            return (MaraudersMap.shared.currentPath, portKey.route)
        }
    }
}
