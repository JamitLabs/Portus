//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public typealias RoutingInstructions = [RoutingInstruction]

public enum RoutingInstruction {
    case leave(entry: RoutingEntry, animated: Bool)
    case enter(entry: RoutingEntry, animated: Bool)
    case switchTo(entry: RoutingEntry, animated: Bool)
}
