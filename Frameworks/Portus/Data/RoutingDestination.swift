// swiftlint:disable:this file_name
//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Typealias representing a static routing destination, i.e., a predefined destination
/// as specified in the routing table
public typealias StaticRoutingDestination = [RoutingEntry]

/// Typealias representing a dynamic routing destination, i.e, a destination that does not depend
/// on the current context and can be entered from everywhere
public typealias DynamicRoutingDestination = RoutingEntry
