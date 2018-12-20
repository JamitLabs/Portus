//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit

public struct Portus {
    public enum AnimationExtent: Int {
        /// No route entrance will be animated.
        case notAtAll

        /// Only the destination entrance will be animated.
        case destinationOnly

        /// All enterings along the route will be animated.
        case fully
    }

    public enum RoutingStrategy: Int {
        /// Routing will always start from the root – resulting in exactly the specified path.
        case alwaysFromRoot

        /// Routing will always start from the root, but reuse any already open paths from the beginning – resulting in exactly the specified path.
        case maxReusageFromRoot

        /// Routing will always start from the leaf, only leaving until any match is found – only the last k (>1) entries are like the specified path.
        case minRouteToLeaf
    }

    public static var window: UIWindow!

    public static func use(portKey: PortKey, animationExtent: AnimationExtent = .notAtAll, routingStrategy: RoutingStrategy = .minRouteToLeaf) {
        let (routeToLeave, routeToEnter) = pathToDestination(portKey: portKey, routingStrategy: routingStrategy)

        recursivelyLeave(route: routeToLeave.reversed(), animated: animationExtent == .fully) {
            recursivelyEnter(route: routeToEnter, from: window!.visibleViewController!, animated: animationExtent == .fully)
        }
    }

    private static func recursivelyLeave(route: [PortKeyLeavable], animated: Bool, completion: @escaping () -> Void) {
        guard let leavable = route.first else { completion(); return }

        leavable.leave(animated: animated) {
            recursivelyLeave(route: Array(route.dropFirst()), animated: animated, completion: completion)
        }
    }

    private static func recursivelyEnter(route: Route, from presentingViewController: UIViewController, animated: Bool) {
        guard let (enterableType, info) = route.first else { return }

        enterableType.enter(from: presentingViewController, info: info, animated: animated) { presentedViewCtrl in
            recursivelyEnter(route: Array(route.dropFirst()), from: presentedViewCtrl, animated: animated)
        }
    }

    internal static func pathToDestination(portKey: PortKey, routingStrategy: RoutingStrategy) -> ([PortKeyLeavable], Route) {
        switch routingStrategy {
        case .alwaysFromRoot:
            return (MaraudersMap.shared.currentPath, portKey.route)

        case .maxReusageFromRoot:
            guard var routeToLeave = MaraudersMap.shared.currentPath as? [PortKeyEnterable] else { return (MaraudersMap.shared.currentPath, portKey.route) }
            var routeToEnter: Route = portKey.route

            for (enterableType, _) in portKey.route {
                guard let firstEntered = routeToLeave.first, type(of: firstEntered).routingId == enterableType.routingId else { return (routeToLeave, routeToEnter) }

                routeToLeave.removeFirst()
                routeToEnter.removeFirst()
            }

            return (routeToLeave, routeToEnter)

        case .minRouteToLeaf:
            var routeToEnter: Route = []

            for routeElement in portKey.route.reversed() {
                if let lastIndex = MaraudersMap.shared.currentPath.lastIndex(where: { $0 is PortKeyEnterable && type(of: $0 as! PortKeyEnterable).routingId == routeElement.enterableType.routingId }) {
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
