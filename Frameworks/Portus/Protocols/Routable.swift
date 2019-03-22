//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public protocol Routable: AnyObject {
    func leave(node: RoutingEntry, animated: Bool, completion: @escaping () -> Void)
    func enter(node: RoutingEntry, animated: Bool, completion: @escaping ((Routable) -> Void))
    func didEnter(withInfo: Any?)
}

extension Routable {
    public func leave(node: RoutingEntry, animated: Bool, completion: @escaping () -> Void) { /* Default implementation */ }
    public func enter(node: RoutingEntry, animated: Bool, completion: @escaping ((Routable) -> Void)) { /* Default implementation */ }
    public func didEnter(withInfo: Any?) { /* Default implementation */ }
}
