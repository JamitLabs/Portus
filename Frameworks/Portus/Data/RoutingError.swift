//
//  Created by Andreas Link on 18.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Error type representing issues that might occur during routing
public enum RoutingError: Error {
    /// Indicates that the destination as requested by the routing initiator
    /// is not reachable from within the current context. Possible reasons might include inconsistencies in the
    /// routing tree, as caused by inappropriate state changes of the routing tree. Please ensure to always inform
    /// the routing tree when a new node is entered, left or switched to. Otherwise, routing may fail.
    case destinationNotReachable
}
