//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

internal enum RoutingAlgorithm {
    internal static func determineRoutingInstructions(
        toDestination destination: Path,
        withRoutingStrategy routingStrategy: RoutingStrategy
    ) -> RoutingInstructions {
        switch routingStrategy {
        case .alwaysFromRoot:
            return RoutingInstruction(
                nodesToLeave: RoutingTree.shared.currentPathWithoutRoot,
                nodesToEnter: Array(destination.dropFirst())
            )

        case .maxReusageFromRoot:
            var nodesToLeave = RoutingTree.shared.currentPathWithoutRoot
            var nodesToEnter: [RoutingEntry] = Array(destination.dropFirst())

            for nodeToLeave in nodesToLeave {
                guard
                    let nodeToEnter = nodesToEnter.first,
                    nodeToEnter.identifier == nodeToLeave.identifier,
                    nodeToEnter.context == nodeToLeave.context
                else {
                    return RoutingInstruction(
                        nodesToLeave: nodesToLeave,
                        nodesToEnter: nodesToEnter
                    )
                }

                nodesToLeave.removeFirst()
                nodesToEnter.removeFirst()
            }

            return RoutingInstruction(
                nodesToLeave: nodesToLeave,
                nodesToEnter: nodesToEnter
            )

        case .minRouteToLeaf:
            var nodesToEnter: [RoutingEntry] = []

            for node in Array(destination.dropFirst()).reversed() {
                if let lastIndex = RoutingTree.shared.currentPathWithoutRoot.lastIndex(
                    where: { $0.identifier == node.identifier && $0.context == node.context }
                ) {
                    let nodesToLeave: [RoutingEntry] = Array(RoutingTree.shared.currentPathWithoutRoot.suffix(from: lastIndex + 1))
                    return RoutingInstruction(
                        nodesToLeave: nodesToLeave,
                        nodesToEnter: nodesToEnter
                    )
                } else {
                    nodesToEnter.insert(node, at: 0)
                }
            }

            return RoutingInstruction(
                nodesToLeave: RoutingTree.shared.currentPathWithoutRoot,
                nodesToEnter: Array(destination.dropFirst())
            )
        }
    }
}
