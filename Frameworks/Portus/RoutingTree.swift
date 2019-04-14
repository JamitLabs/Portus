//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public class RoutingTree {
    public static let `default`: RoutingTree = RoutingTree()

    internal var root: RoutingNode?

    internal init(root: RoutingNode? = nil) {
        self.root = root
    }

    internal init(from routingTree: RoutingTree) {
        self.root = routingTree.root?.deepCopy()
    }

    public func didEnterSwitchableNode(
        with entry: RoutingEntry,
        entriesOfManagedNodes: [RoutingEntry],
        entryOfActiveNode: RoutingEntry
    ) {
        let children = entriesOfManagedNodes.map { entry in
            RoutingNode(entry: entry, isActive: entry == entryOfActiveNode)
        }

        guard let root = root else {
            self.root = RoutingNode(entry: entry, isActive: true)
            self.root?.add(children: children)
            return
        }

        root.findNode(for: entry)?.add(children: children)
        print(root.description)
    }

    public func didEnterNode(with entry: RoutingEntry) {
        guard let root = root else {
            return self.root = RoutingNode(entry: entry, isActive: true)
        }

        root.add(activeLeaf: RoutingNode(entry: entry, isActive: true))
        print(root.description)
    }

    public func didLeaveNode(with entry: RoutingEntry) {
        guard let node = root?.findNode(for: entry) else {
            fatalError("[RoutingTree] Error: Node \(entry.identifier.rawValue) not found.")
        }

        node.removeNode()
        print(root?.description ?? "")
    }

    public func didSwitchToNode(with targetEntry: RoutingEntry, fromNodeWith originEntry: RoutingEntry) {
        guard let originNode = root?.findNode(for: originEntry) else {
            fatalError("[RoutingTree] Error: Origin Node \(originEntry.identifier.rawValue) not found.")
        }

        originNode.changeActiveChild(toNodeWith: targetEntry)
        print(root?.description ?? "")
    }
}

extension RoutingTree: CustomStringConvertible {
    public var description: String {
        var description: String = ""
        description += root?.description ?? ""
        return description
    }
}
