//
//  Created by Andreas Link on 05.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Routables that can enter additional nodes for given entries.
public protocol Enterable: Routable {
    /// Called when a node should be entered. The target node is identified by the given entry.
    ///
    /// - Parameters:
    ///     - entry: An entry identifiying the node to be entered
    ///     - animated: `true` if the entering of the target node should be animated
    ///     - completion: Called when the operation either failed or succeeded as indicated by the provided boolean.
    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void))
}
