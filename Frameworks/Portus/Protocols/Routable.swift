//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public protocol Routable: AnyObject {
    var entry: RoutingEntry { get }
}
