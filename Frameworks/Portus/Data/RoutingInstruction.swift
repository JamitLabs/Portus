//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Enum, defining the different types of routing instructions that can be executed on a routing tree.
public enum RoutingInstruction {
    /// Routing instruction, representing a node to be entered
    ///
    /// - Parameters:
    ///     - entry: An entry of the node to enter
    ///     - animated: `true` if the operation should be aninmated
    case enter(entry: RoutingEntry, animated: Bool)

    /// Routing instruction, representing a node to leave
    ///
    /// - Parameters:
    ///     - entry: An entry of the node to leave
    ///     - animated: `true` if the operation should be aninmated
    case leave(entry: RoutingEntry, animated: Bool)

    /// Routing instruction, representing a node to switch to
    ///
    /// - Parameters:
    ///     - entry: An entry of the node to switch to
    ///     - switchNodeEntry: An entry representing the switchable node that contains the target node
    ///                        as one of its managed nodes
    ///     - animated: `true` if the operation should be animated
    case switchTo(entry: RoutingEntry, switchNodeEntry: RoutingEntry, animated: Bool)
}

// MARK: - CustomStringConvertible
extension RoutingInstruction: CustomStringConvertible {
    /// A textual representation of the instruction.
    public var description: String {
        switch self {
        case let .enter(entry, _):
            return "enter(\(entry.identifier.rawValue))"

        case let .leave(entry, _):
            return "leave(\(entry.identifier.rawValue))"

        case let .switchTo(entry, _, _):
            return "switchTo(\(entry.identifier.rawValue))"
        }
    }
}
