//
//  Created by Andreas Link on 05.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public protocol Switchable: Routable {
    func switchTo(node: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void))
    func canSwitchTo(node: RoutingEntry) -> Bool
}
