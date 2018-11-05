//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

class ScreenFlowTree {
    private static var tree: Node?
    private static var routables: [Path.Identifier: Routable] = [:]

    static func addRoutable(_ routable: Routable, with parent: Routable?) {
        let identifier = routable.identifier

        guard routables.keys.contains(identifier) else { fatalError("A routable object with the given identifier already exists.") }

        // NOTE: We check whether a root node alredy exists, otherwise we initialize the tree with the given routable
        if tree == nil && parent == nil {
            tree = Node(identifier: identifier)
        } else {
            guard let parent = parent else { fatalError("The given routable can not be inserted into tree; no parent given.") }
            guard let parentNode = tree?.getNodeWith(identifier: parent.identifier) else { fatalError("No node could be found for the given parent.") }

            parentNode.subNodes.append(Node(identifier: identifier, subNodes: []))
        }

        routables[identifier] = routable
    }

    static func emptyTree() {
        self.tree = nil
        self.routables = [:]
    }

    static func removeRoutable(_ routable: Routable) {
        guard let tree = tree else { return }

        guard tree.identifier != routable.identifier else { return emptyTree() }
        guard let nodeForRoutable = tree.getNodeWith(identifier: routable.identifier) else { return }
        guard let parent = nodeForRoutable.parent else { return }
        parent.removeSubNode(with: routable.identifier)

        // TODO remove all parents from the given node 

        routables[routable.identifier] = nil
    }

    static func getRoutableWith(identifier: Path.Identifier) -> Routable? {
        return routables[identifier]
    }
}

class Node {
    var identifier: Path.Identifier
    var parent: Node?
    var subNodes: [Node]

    init(identifier: Path.Identifier, parent: Node? = nil, subNodes: [Node] = []) {
        self.identifier = identifier
        self.parent = parent
        self.subNodes = subNodes
    }

    func removeSubNode(with identifier: Path.Identifier) {
        guard let indexToRemove = subNodes.firstIndex(where: { $0.identifier == identifier }) else { return }
        subNodes.remove(at: indexToRemove)
    }

    func getNodeWith(identifier: Path.Identifier) -> Node? {
        if identifier == identifier {
            return self
        } else {
            for subNode in subNodes { if let targetNode = subNode.getNodeWith(identifier: identifier) { return targetNode } }
        }

        return nil
    }
}
