//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public final class Map {
    public static let shared = Map()

    internal var currentPath: [Node] = []
    internal var currentPathWithoutRoot: [Node] {
        return [Node](currentPath.dropFirst())
    }

    private init() {}

    public func didEnter(_ node: Node) {
        currentPath.append(node)
        print(description)
    }

    public func didLeave(_ node: Node) {
        if let lastIndex = currentPath.lastIndex(where: { $0 == node }) {
            currentPath.removeLast(currentPath.count - lastIndex)
        }

        print("After Leave: \(description)")
    }
}

extension Map: CustomStringConvertible {
    public var description: String {
        return currentPath.map {
            var description: String = ""

            description += $0.identifier.rawValue
            let doParametersExist: Bool = $0.parameters?.isEmpty == false
            if doParametersExist { description += " [" }
            $0.parameters?.forEach { key, value in
                description += "\(key):\(value),"
            }

            if doParametersExist { description.removeLast(); description += "]" }
            return description
        }.joined(separator: " > ")
    }
}
