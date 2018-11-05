//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public struct Path {
    // MARK: - Subtypes
    var components: [RoutableID]
    var nextPathComponent: RoutableID? { return components.first }
    var remainingPath: Path { return Path(components: [RoutableID](components.dropFirst())) }
}
