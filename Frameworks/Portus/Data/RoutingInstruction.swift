//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public typealias RoutingInstructions = [RoutingInstruction]

public enum RoutingInstruction: CustomStringConvertible {
    case enter(entry: RoutingEntry, animated: Bool)
    case leave(entry: RoutingEntry, animated: Bool)
    case switchTo(entry: RoutingEntry, from: RoutingEntry, animated: Bool)

    public var description: String {
        switch self {
        case let .enter(entry, _):
            return "enter(\(entry.identifier.rawValue))"

        case let .leave(entry, _):
            return "leave(\(entry.identifier.rawValue))"

        case let .switchTo(entry, _, _):
            return "switchTo(\(entry.identifier.rawValue))"
        }
    }
}
