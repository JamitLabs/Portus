//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public struct RoutingEntry {
    public var identifier: RoutingID
    public var context: RoutingContext?
    weak var routable: Routable?

    public init(identifier: RoutingID, context: RoutingContext? = nil, routable: Routable? = nil) {
        self.identifier = identifier
        self.context = context
        self.routable = routable
    }
}

// MARK: - Equatable
extension RoutingEntry: Equatable {
    public static func == (lhs: RoutingEntry, rhs: RoutingEntry) -> Bool {
        if let lhsRoutable = lhs.routable, let rhsRoutable = rhs.routable {
            return lhs.identifier == rhs.identifier && lhs.context == rhs.context && lhsRoutable === rhsRoutable
        } else {
            return lhs.identifier == rhs.identifier && lhs.context == rhs.context
        }
    }
}
