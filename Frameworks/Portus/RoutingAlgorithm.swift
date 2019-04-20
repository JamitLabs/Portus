//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

enum RoutingAlgorithm {
    static func computeRoutingInstructions(
        in routingTree: RoutingTree,
        to destination: StaticRoutingDestination,
        and instructions: RoutingInstructions = [],
        completion: @escaping (Result<RoutingInstructions, RoutingError>) -> Void
    ) {
        let router = Router(routingTree: routingTree)
        let origin = Array(routingTree.root?.activePath() ?? []).map { $0.entry }

        guard origin != destination else {
            completion(.success(instructions))
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

                return leavable.canLeaveNode(with: entry) ? .leave(entry: entry, animated: true) : nil
            }

            if let switchEntry = origin[try: index - 1], let switchable = switchEntry.routable as? Switchable {
                guard switchable.canSwitchToNode(with: destination[index]) else { return [] }

                nextChunkOfInstructions.append(
                    .switchTo(entry: destination[index], switchNodeEntry: switchEntry, animated: true)
                )
            } else if let enterEntry = destination[try: index] {
                nextChunkOfInstructions.append(.enter(entry: enterEntry, animated: true))
            }

            return nextChunkOfInstructions
        }()

        guard !nextChunkOfRoutingInstructions.isEmpty else {
            return completion(.failure(.destinationNotReachable))
        }

        router.simulate(routingInstructions: nextChunkOfRoutingInstructions) {
            computeRoutingInstructions(
                in: routingTree,
                to: destination,
                and: instructions + nextChunkOfRoutingInstructions,
                completion: completion
            )
        }
    }
}
