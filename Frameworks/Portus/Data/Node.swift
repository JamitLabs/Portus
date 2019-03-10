//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public struct Node {
    public var identifier: RoutingId
    var routable: Routable?
    public var parameters: RoutingParameters?

    public init (identifier: RoutingId, routable: Routable? = nil, parameters: RoutingParameters? = nil) {
        self.identifier = identifier
        self.routable = routable
        self.parameters = parameters
    }

    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.routable === rhs.routable && lhs.parameters == rhs.parameters
    }
}
