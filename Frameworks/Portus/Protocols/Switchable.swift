//
//  Created by Andreas Link on 05.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Routables that manage additional nodes haveing one of them being active at any time.
public protocol Switchable: Routable {
    /// Called when the `Switchable` should swith to a different node out of its managed nodes.
    ///
    /// - Parameters:
    ///     - entry: The entry of the target node the `Switchable` should switch to.
    ///     - animated: A Boolean indicating whether the switch to the target node should be animated.
    ///     - completion: Called when the operation succeeded or failed.
    func switchToNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void))
}
