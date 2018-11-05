//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

internal final class RoutingTree {
    // MARK: - Properties
    static let shared = RoutingTree()
    private var routables: [RoutableID: Routable] = [:]
    private var rootNode: Node?

    // MARK: - Initializers
    private init() {}

    // MARK: - Methods
    func getRoutableWith(identifier: RoutableID) -> Routable? {
        return routables[identifier]
    }

    func add(routable: Routable, parent: Routable?) {
        guard routables.keys.contains(routable.routableID) else { fatalError("A routable object with the given ID already exists.") }

        if rootNode == nil && parent == nil {
            // NOTE: In case that no root node exists, we initialize the tree with the given routable
            rootNode = Node(routableID: routable.routableID)
        } else {
            // NOTE: Otherwise, we insert the given routable into the existing tree
            guard let parent = parent else { fatalError("The given routable can not be inserted into tree: No parent given.") }
            guard let parentNode = rootNode?.nodeUsingDFS(routableID: parent.routableID) else { fatalError("No node could be found for the given parent.") }

            parentNode.subNodes.append(Node(routableID: routable.routableID))
        }

        routables[routable.routableID] = routable
    }

    func removeRoutable(_ routable: Routable) {
        guard let rootNode = rootNode else { return }

        guard rootNode.routableID != routable.routableID else { return resetTree() }
        guard let nodeToRemove = rootNode.nodeUsingDFS(routableID: routable.routableID) else { return }
        guard let parentOfNodeToRemove = nodeToRemove.parentNode else { return }
        parentOfNodeToRemove.removeSubNode(routableID: routable.routableID)

        // NOTE: Remove all routables associated to the subtree defined by the node to remove
        func removeAllRoutables(from node: Node) {
            routables[node.routableID] = nil
            guard !node.subNodes.isEmpty else { return }
            node.subNodes.forEach { removeAllRoutables(from: $0) }
        }

        removeAllRoutables(from: nodeToRemove)
    }

    func resetTree() {
        self.rootNode = nil
        self.routables = [:]
    }
}
