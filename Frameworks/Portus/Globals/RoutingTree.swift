//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

internal class RoutingTree {
    // MARK: - Properties
    private static let shared = RoutingTree()
    private var root: Node?
    private var routables: [RoutingID: Routable] = [:]

    // MARK: - Initializers
    private init() {}

    // MARK: - Methods
    func addRoutable(_ routable: Routable) {
        let identifier = routable.identifier

        guard routables.keys.contains(identifier) else { fatalError("A routable object with the given identifier already exists.") }

        // NOTE: We check whether a root node already exists, otherwise we initialize the tree with the given routable
        if root == nil && parent == nil {
            root = Node(identifier: identifier)
        } else {
            guard let parent = parent else { fatalError("The given routable can not be inserted into tree; no parent given.") }
            guard let parentNode = root?.getNodeWith(identifier: parent.identifier) else { fatalError("No node could be found for the given parent.") }

            parentNode.subNodes.append(Node(identifier: identifier, subNodes: []))
        }

        routables[identifier] = routable
    }

    func emptyTree() {
        self.root = nil
        self.routables = [:]
    }

    func removeRoutable(_ routable: Routable) {
        guard let root = root else { return }

        guard root.identifier != routable.identifier else { return emptyTree() }
        guard let nodeForRoutable = root.getNodeWith(identifier: routable.identifier) else { return }
        guard let parent = nodeForRoutable.parent else { return }
        parent.removeSubNode(with: routable.identifier)

        // TODO remove all parents from the given node 

        routables[routable.identifier] = nil
    }

    func getRoutableWith(identifier: RoutingID) -> Routable? {
        return routables[identifier]
    }
}
