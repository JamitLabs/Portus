//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public struct Path {
    // MARK: - Subtypes
    var components: [RoutingID]
    var firstPathComponent: RoutingID? { return components.first }
    var remainingPath: Path { return Path(components: [RoutingID](components.dropFirst())) }
}
