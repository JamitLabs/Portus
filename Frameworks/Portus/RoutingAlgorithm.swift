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
    ///                   An empty set of instructions indicates that the destination is reached.
    static internal func computeNextRoutingInstructions(
        to destination: StaticRoutingDestination,
        completion: @escaping (Result<RoutingInstructions, RoutingError>) -> Void
    ) {
        let origin = Array(RoutingTree.default.root?.activePath() ?? []).map { $0.entry }

        guard origin != destination else {
            completion(.success([]))
            return
        }

        let nextChunkOfRoutingInstructions: RoutingInstructions = {
            var nextChunkOfInstructions: RoutingInstructions = []

            let maxIndex = max(origin.count, destination.count)
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

            nextChunkOfInstructions += Array(origin.suffix(from: index)).reversed().compactMap { entry in
                guard let leavable = entry.routable as? Leavable else { return nil }

                return leavable.canLeaveNode(with: entry) ? .leave(entry: entry) : nil
            }

            if
                let switchNode = (RoutingTree.default.root?.activePath() ?? [])[try: index - 1],
                switchNode.children.count > 1
            {
                guard
                    switchNode.children.map({ $0.entry.identifier }).contains(destination[index].identifier)
                else {
                    return []
                }

                nextChunkOfInstructions.append(
                    .switchTo(entry: destination[index], switchNodeEntry: switchNode.entry)
                )
            } else if let enterEntry = destination[try: index] {
                nextChunkOfInstructions.append(.enter(entry: enterEntry))
            }

            return nextChunkOfInstructions
        }()

        guard !nextChunkOfRoutingInstructions.isEmpty else {
            return completion(.failure(.destinationNotReachable))
        }

        completion(.success(nextChunkOfRoutingInstructions))
    }
}
