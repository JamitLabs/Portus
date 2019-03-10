//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public final class RoutingTree {
    public static let shared = RoutingTree()

    internal var currentPath: [RoutingEntry] = []
    internal var currentPathWithoutRoot: [RoutingEntry] {
        return [RoutingEntry](currentPath.dropFirst())
    }

    private init() {}

    public func didEnter(_ node: RoutingEntry) {
        currentPath.append(node)
        print(description)
    }

    public func didLeave(_ node: RoutingEntry) {
        if let lastIndex = currentPath.lastIndex(where: { $0 == node }) {
            currentPath.removeLast(currentPath.count - lastIndex)
        }

        print("After Leave: \(description)")
    }
}

extension RoutingTree: CustomStringConvertible {
    public var description: String {
        return currentPath.map {
            var description: String = ""

            description += $0.identifier.rawValue
            let doParametersExist: Bool = $0.context?.isEmpty == false
            if doParametersExist { description += " [" }
            $0.context?.forEach { key, value in
                description += "\(key):\(value),"
            }

            if doParametersExist { description.removeLast(); description += "]" }
            return description
        }.joined(separator: " > ")
    }
}
