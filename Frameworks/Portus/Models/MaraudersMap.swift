//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public final class MaraudersMap {
    public static let shared = MaraudersMap()

    internal var currentPath: [PortKeyLeavable] = []

    public var portKeyEnterablesPath: String {
        let enterables: [PortKeyEnterable] = currentPath.compactMap { $0 as? PortKeyEnterable }
        return enterables.map { type(of: $0).routingId }.joined(separator: " > ")
    }

    private init() {}

    public func didEnter(_ leavable: PortKeyLeavable) {
        currentPath.append(leavable)
    }

    public func didLeave(_ leavable: PortKeyLeavable) {
        if let lastIndex = currentPath.lastIndex(where: { $0 === leavable}) {
            currentPath.removeLast(currentPath.count - lastIndex)
        }
    }
}
