//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Classes conforming to `Routable` can be handled by the `Router`. Note that `Routables` can state their capabilities
/// by conforming to the `Enterable`, `Leavable` or `Switchable` protocol.
public protocol Routable: AnyObject {
    var entry: RoutingEntry { get }
}
