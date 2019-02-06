//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit

public typealias RoutingIdentifier = String

public enum RoutingIdentifiers {}

public protocol Routable: class {
    static var routingId: RoutingIdentifier { get }
    func enter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool, completion: @escaping (Routable) -> Void)
    func leave(animated: Bool, completion: @escaping () -> Void)
    func willEnter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool)
}

public extension Routable { // swiftlint:disable:this no_extension_access_modifier
    func willEnter(routingIdentifier: RoutingIdentifier, info: Any?, animated: Bool) { /* Default Implementation */ }
}
