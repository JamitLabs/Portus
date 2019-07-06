//
//  Created by Andreas Link on 05.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Routables that can leave nodes as specified b given entries.
public protocol Leavable: Routable {
    /// Called when a node should be left. The node to be left is identified by the given entry.
    ///
    /// - Parameters:
    ///     - entry: An entry identifiying the node to be left
    ///     - animated: `true` if the leaving of the given node should be animated
    ///     - completion: Called when the operation either failed or succeeded as indicated by the given boolean.
    func leaveNode(with entry: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void)

    /// Called to ask a `Leavable` about whether it can leave the node for the given entry.
    ///
    /// - Parameters:
    ///     - entry: An entry identifying the node to be left.
    func canLeaveNode(with entry: RoutingEntry) -> Bool
}
