//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Data structure to keep track of the screenflow within the app and used for routing computations.
public class RoutingTree {
    /// The default routing tree, used to keep track of the screenflow within the app
    public static let `default`: RoutingTree = RoutingTree()

    var root: RoutingNode?

    init(root: RoutingNode? = nil) {
        self.root = root
    }

    /// Called to indicate that the node for the given entry got entered successfully.
    /// The node is added as active leaf to the routing tree including its managed entries.
    ///
    /// - Parameters:
    ///     - entry: The entry of the node that got entered.
    public func didEnterNode(withEntry entry: RoutingEntry) {
        if let managedEntries = entry.managedEntries {
            let children = managedEntries.entries.map { entry in
                RoutingNode(entry: entry, isActive: entry == managedEntries.activeEntry)
            }

            guard let root = root else {
                self.root = RoutingNode(entry: entry, isActive: true)
                self.root?.add(children: children)
                return
            }

            if let node = root.findNode(for: entry) {
                node.add(children: children)
            } else {
                root.add(activeLeaf: RoutingNode(entry: entry, isActive: true))
                root.findNode(for: entry)?.add(children: children)
            }
        } else {
            guard let root = root else {
                return self.root = RoutingNode(entry: entry, isActive: true)
            }

            root.add(activeLeaf: RoutingNode(entry: entry, isActive: true))
        }
    }

    /// Called to indicate that the node for the given entry is left successfully.
    /// The node is removed from the routing tree.
    ///
    /// - Parameters:
    ///     - entry: The entry of the node that is left.
    public func didLeaveNode(with entry: RoutingEntry) {
        guard let node = root?.findNode(for: entry) else {
            fatalError("[RoutingTree] Error: Node \(entry.identifier.rawValue) not found.")
        }

        node.removeNode()
    }

    /// Called to indicate that the active node did change to the node identified by the given `targetEntry`.
    ///
    /// - Parameters:
    ///     - entry: The entry of the switchable node that contains the node target node as a managed child
    ///     - targetEntry: The entry of the node out of the managed nodes that got active.
    public func switchNode(withEntry entry: RoutingEntry, didSwitchToNodeWithEntry targetEntry: RoutingEntry) {
        guard let node = root?.findNode(for: entry) else {
            fatalError("[RoutingTree] Error: Node with identifier: \(entry.identifier.rawValue) not found.")
        }

        node.changeActiveChild(toNodeWithEntry: targetEntry)
    }
}

// MARK: - CustomStringConvertible
extension RoutingTree: CustomStringConvertible {
    /// A short description of the node including all its children.
    public var description: String {
        var description: String = ""
        description += root?.description ?? ""
        return description
    }
}
