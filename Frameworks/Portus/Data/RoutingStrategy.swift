//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public enum RoutingStrategy: Int {
    /// Routing will always start from the root – resulting in exactly the specified path.
    case alwaysFromRoot

    /// Routing will always start from the root, but reuse any already open paths from the beginning – resulting in exactly the specified path.
    case maxReusageFromRoot

    /// Routing will always start from the leaf, only leaving until any match is found – only the last k (>1) entries are like the specified path.
    case minRouteToLeaf
}
