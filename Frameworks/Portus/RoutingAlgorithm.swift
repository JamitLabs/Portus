//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

internal enum RoutingAlgorithm {
    internal static func determineRoutingInstructions(
        toDestination destination: Path,
        withRoutingStrategy routingStrategy: RoutingStrategy
    ) -> RoutingInstruction {
        switch routingStrategy {
        case .alwaysFromRoot:
            return RoutingInstruction(
                nodesToLeave: Map.shared.currentPathWithoutRoot,
                nodesToEnter: Array(destination.dropFirst())
            )

        case .maxReusageFromRoot:
            var nodesToLeave = Map.shared.currentPathWithoutRoot
            var nodesToEnter: [Node] = Array(destination.dropFirst())

            for nodeToLeave in nodesToLeave {
                guard
                    let nodeToEnter = nodesToEnter.first,
                    nodeToEnter.identifier == nodeToLeave.identifier,
                    nodeToEnter.parameters == nodeToLeave.parameters
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
            var nodesToEnter: [Node] = []

            for node in Array(destination.dropFirst()).reversed() {
                if let lastIndex = Map.shared.currentPathWithoutRoot.lastIndex(
                    where: { $0.identifier == node.identifier && $0.parameters == node.parameters }
                ) {
                    let nodesToLeave: [Node] = Array(Map.shared.currentPathWithoutRoot.suffix(from: lastIndex + 1))
                    return RoutingInstruction(
                        nodesToLeave: nodesToLeave,
                        nodesToEnter: nodesToEnter
                    )
                } else {
                    nodesToEnter.insert(node, at: 0)
                }
            }

            return RoutingInstruction(
                nodesToLeave: Map.shared.currentPathWithoutRoot,
                nodesToEnter: Array(destination.dropFirst())
            )
        }
    }
}
