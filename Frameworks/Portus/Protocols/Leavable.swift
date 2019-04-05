//
//  Created by Andreas Link on 05.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

protocol Leavable: Routable {
    func leave(node: RoutingEntry, animated: Bool, completion: @escaping () -> Void)
    func shouldLeave(node: RoutingEntry) -> Bool
}

extension Leavable {
    func shouldLeave(node: RoutingEntry) -> Bool { return true }
}
