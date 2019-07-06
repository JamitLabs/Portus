//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Enum, defining the different types of routing instructions that can be executed on a routing tree.
public enum RoutingInstruction: Equatable {
    /// Routing instruction, representing a node to be entered
    ///
    /// - Parameters:
    ///     - entry: An entry of the node to enter
    case enter(entry: RoutingEntry)

    /// Routing instruction, representing a node to leave
    ///
    /// - Parameters:
    ///     - entry: An entry of the node to leave
    case leave(entry: RoutingEntry)

    /// Routing instruction, representing a node to switch to
    ///
    /// - Parameters:
    ///     - entry: An entry of the node to switch to
    ///     - switchNodeEntry: An entry representing the switchable node that contains the target node
    ///     as one of its managed nodes
    case switchTo(entry: RoutingEntry, switchNodeEntry: RoutingEntry)
}

// MARK: - CustomStringConvertible
extension RoutingInstruction: CustomStringConvertible {
    /// A textual representation of the instruction.
    public var description: String {
        switch self {
        case let .enter(entry):
            return "enter(\(entry.identifier.rawValue))"

        case let .leave(entry):
            return "leave(\(entry.identifier.rawValue))"

        case let .switchTo(entry, _):
            return "switchTo(\(entry.identifier.rawValue))"
        }
    }
}
