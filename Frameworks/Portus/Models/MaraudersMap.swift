//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

final class MaraudersMap {
    static let shared = MaraudersMap()

    internal var currentPath: [PortKeyLeavable] = []

    private init() {}

    func didEnter(_ leavable: PortKeyLeavable) {
        currentPath.append(leavable)
    }

    func didLeave(_ leavable: PortKeyLeavable) {
        if let lastIndex = currentPath.lastIndex(where: { $0 === leavable}) {
            currentPath.removeLast(currentPath.count - lastIndex)
        }
    }
}
