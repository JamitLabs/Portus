//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

struct Path {
    var routables: [Routable]
    var currentPathComponent: Routable? { return routables.first }
    var remainingPathComponents: [Routable] { return routables.dropFirst() }
}
