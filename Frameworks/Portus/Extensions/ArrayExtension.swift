//
//  Created by Andreas Link on 10.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

extension Array where Element == RoutingId {
    public var nodes: [Node] {
        return self.map { Node(identifier: $0) }
    }
}
