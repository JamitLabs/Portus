//
//  Created by Andreas Link on 10.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

extension Array where Element == RoutingIdentifier {
    /// Routing entry list definition shorthand
    public var entries: [RoutingEntry] {
        return self.map { RoutingEntry(identifier: $0) }
    }
}
