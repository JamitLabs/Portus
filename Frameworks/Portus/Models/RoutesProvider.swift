//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public typealias Context = [RoutingIdentifier]

public protocol ContextProvider {
    var contexts: [Context] { get }
}
