//
//  Created by Andreas Link on 05.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public protocol Enterable: Routable {
    func enter(node: RoutingEntry, animated: Bool, completion: @escaping ((Routable) -> Void))
    static func canEnter(node: RoutingEntry) -> Bool
}
