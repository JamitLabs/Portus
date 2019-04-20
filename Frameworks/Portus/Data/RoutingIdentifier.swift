//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Data structure identifying a routing node. Combined with a context, it uniquely identifies the routing node.
public struct RoutingIdentifier: RawRepresentable, Equatable {
    /// The associated type to satisfy the `RawRepresantable``requirement.
    public typealias RawValue = String

    /// The rawValue associated with the identifier
    public var rawValue: String

    /// Initializes a `RoutingIdentifier`.
    ///
    /// - Parameter rawValue: The rawValue of the identifier
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - Hashable
extension RoutingIdentifier: Hashable {
    /// Computes a hash value for the identifier.
    ///
    /// - Parameter hasher: A `Hasher` instance used to compute a hash value from the essential components
    /// of the identifier.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
