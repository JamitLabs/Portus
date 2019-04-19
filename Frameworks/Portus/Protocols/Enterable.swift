//
//  Created by Andreas Link on 05.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public protocol Enterable: Routable {
    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void))
}
