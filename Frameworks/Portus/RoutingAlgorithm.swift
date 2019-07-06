//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

enum RoutingAlgorithm {
    /// Routing algorithm computing the next chunk of routing instructions to a given destination.
    ///
    /// - Parameters:
    ///     - destination: The destination to route to, defined as static entry within the `RoutingTable`.
    ///     - completion: Called with the next chunk of routing instructions or an error that occured within routing.
    ///     An empty set of instructions indicates that the destination is reached.
    internal static func computeNextRoutingInstructions( // swiftlint:disable:this cyclomatic_complexity
        to destination: StaticRoutingDestination,
        completion: @escaping (Result<RoutingInstructions, RoutingError>) -> Void
    ) {
        let activePath = Array(RoutingTree.default.root?.activePath() ?? [])
        let origin = activePath.map { $0.entry }

        guard origin != destination else {
            completion(.success([]))
            return
        }

        let nextChunkOfRoutingInstructions: RoutingInstructions = {
            let maxIndex = max(origin.count, destination.count)

            /// We need to determine the first mismatch index, i.e., the first index from which on the origin and destination path do not match
            let firstMismatchIndex: Int? = {
                for index in 0 ... maxIndex {
                    guard
                        let originEntry = origin[try: index],
                        let destinationEntry = destination[try: index],
                        originEntry == destinationEntry
                    else {
                        return index
                    }
                }

                return nil
            }()

            guard let index = firstMismatchIndex else { return [] }

            /// Case 1: Handle Leavables
            /// To guarantee that the desired destination is reachable from the current context, we only need to ensure that all leavable nodes along the path
            /// starting from the node corresponding to the first mismatch index up to the active leaf that are not managed by their parent can be left.
            /// This is determined by asking canLeaveNode(with: entry).
            var leavingRoutingInstructions: RoutingInstructions = []
            let canLeaveCurrentContext: Bool = {
                for node in activePath.suffix(from: index).reversed() {
                    guard let leavable = node.entry.routable as? Leavable, !node.isManagedByParent else { continue }

                    guard leavable.canLeaveNode(with: node.entry) else { return false }

                    leavingRoutingInstructions += [.leave(entry: node.entry)]
                }

                return true
            }()

            guard canLeaveCurrentContext else { return [] }
            guard leavingRoutingInstructions.isEmpty else { return leavingRoutingInstructions }

            /// Case 2: Handle Switchables
            /// Check wether the predecessor of active leaf is Switchable and contains the target node as one of his children, in this case change
            /// the active child to the target node
            if
                let switchNode = (RoutingTree.default.root?.activePath() ?? [])[try: index - 1],
                switchNode.children.count > 1
            {
                guard switchNode.children.map({ $0.entry.identifier }).contains(destination[index].identifier) else { return [] }

                return [.switchTo(entry: destination[index], switchNodeEntry: switchNode.entry)]
            }

            /// Case 3: Handle Enterables
            if let enterEntry = destination[try: index] {
                return [.enter(entry: enterEntry)]
            }

            return []
        }()

        guard !nextChunkOfRoutingInstructions.isEmpty else {
            return completion(.failure(.destinationNotReachable))
        }

        completion(.success(nextChunkOfRoutingInstructions))
    }
}
