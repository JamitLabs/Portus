//
//  Created by Andreas Link on 19.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Contained entries refer to either a static or dynamic routing destination. Static destinations refer to
public enum RoutingTable {
    /// Entries referring to static destinations, i.e., destinations that depend on the current context
    public enum StaticEntries { /* Meant for extension*/ }

    /// Entries referring to dynamic destinations, i.e., destinations that are context independent
    /// and can be entered from everywhere
    public enum DynamicEntries { /* Meant for extension*/ }
}
