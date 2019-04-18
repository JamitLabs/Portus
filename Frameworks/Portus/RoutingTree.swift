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

    public func didEnterNode(withEntry entry: RoutingEntry) {
        guard let root = root else {
            return self.root = RoutingNode(entry: entry, isActive: true)
        }

        root.add(activeLeaf: RoutingNode(entry: entry, isActive: true))
    }

    public func didEnterSwitchNode(
        withEntry entry: RoutingEntry,
        andManagedNodeEntries managedNodeEntries: [RoutingEntry],
        andActiveNodeEntry activeNodeEntry: RoutingEntry
    ) {
        let children = managedNodeEntries.map { entry in
            RoutingNode(entry: entry, isActive: entry == activeNodeEntry)
        }

        guard let root = root else {
            self.root = RoutingNode(entry: entry, isActive: true)
            self.root?.add(children: children)
            return
        }

        root.findNode(for: entry)?.add(children: children)
    }

    public func didLeaveNode(with entry: RoutingEntry) {
        guard let node = root?.findNode(for: entry) else {
            fatalError("[RoutingTree] Error: Node \(entry.identifier.rawValue) not found.")
        }

        node.removeNode()
    }

    public func switchNode(withEntry entry: RoutingEntry, didSwitchToNodeWithEntry targetEntry: RoutingEntry) {
        guard let node = root?.findNode(for: entry) else {
            fatalError("[RoutingTree] Error: Node with identifier: \(entry.identifier.rawValue) not found.")
        }

        node.changeActiveChild(toNodeWithEntry: targetEntry)
    }
}

// MARK: - CustomStringConvertible
extension RoutingTree: CustomStringConvertible {
    public var description: String {
        var description: String = ""
        description += root?.description ?? ""
        return description
    }
}
