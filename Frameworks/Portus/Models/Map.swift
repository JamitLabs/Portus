//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public final class Map {
    public static let shared = Map()

    internal var currentPath: [Routable] = []

    public var currentPathDescription: String {
        return currentPath.map { type(of: $0).routingId }.joined(separator: " > ")
    }

    private init() {}

    public func didEnter(_ routable: Routable) {
        currentPath.append(routable)
    }

    public func didLeave(_ routable: Routable) {
        if let lastIndex = currentPath.lastIndex(where: { $0 === routable }) {
            currentPath.removeLast(currentPath.count - lastIndex)
        }
    }
}
