//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public struct RoutingEntry: Equatable {
    public var identifier: RoutingId
    public var context: RoutingContext?
    weak var routable: Routable?

    public init(identifier: RoutingId, context: RoutingContext? = nil, routable: Routable? = nil) {
        self.identifier = identifier
        self.context = context
        self.routable = routable
    }

    public static func == (lhs: RoutingEntry, rhs: RoutingEntry) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.context == rhs.context
    }
}
