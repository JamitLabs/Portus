//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public protocol Routable: AnyObject {
    func leave(_ nodeToLeave: Node, animated: Bool, completion: @escaping () -> Void)
    func enter(_ nodeToEnter: Node, animated: Bool, completion: @escaping ((Routable) -> Void))
    func didEnterWithInfo(_ info: Any?)
}

extension Routable {
    public func leave(_ nodeToLeave: Node, animated: Bool, completion: @escaping () -> Void) { /* Default implementation */ }
    public func enter(_ nodeToEnter: Node, animated: Bool, completion: @escaping ((Routable) -> Void)) { /* Default implementation */ }
    public func didEnterWithInfo(_ info: Any?) { /* Default implementation */ }
}
