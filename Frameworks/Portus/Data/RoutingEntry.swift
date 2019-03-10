//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public struct RoutingEntry {
    public var identifier: RoutingId
    weak var routable: Routable?
    public var context: RoutingContext?

    public init(identifier: RoutingId, routable: Routable? = nil, context: RoutingContext? = nil) {
        self.identifier = identifier
        self.routable = routable
        self.context = context
    }

    public static func == (lhs: RoutingEntry, rhs: RoutingEntry) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.routable === rhs.routable && lhs.context == rhs.context
    }
}
