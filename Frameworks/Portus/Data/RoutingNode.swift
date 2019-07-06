//
//  Created by Andreas Link on 10.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

/// Data structure for represnting a node in the routing tree.
class RoutingNode {
    /// The entry that uniquely identifies the node, including routing identifier and context
    var entry: RoutingEntry

    /// Flag indicating, whether the node is contained within the active path
    var isActive: Bool

    /// Flag indicating, whether the node is managed by the parent node
    var isManagedByParent: Bool

    /// The parent node of the node if it exists, `nil` otherwise
    weak var parent: RoutingNode?

    /// A list of children of the node. If empty, the node is a leaf node
    private(set) var children: [RoutingNode]

    /// Initializes a RoutingNode
    ///
    /// - Parameters:
    ///     - entry: The entry that uniquely identifies the node
    ///     - isActive: Flag indicating whether the node is contained within the active path
    ///     - parent: The parent node of the node if it exists, `nil` otherwise
    ///     - children: A list of children of the node. If empty, the node is a leaf node
    init(entry: RoutingEntry, isActive: Bool, isManagedByParent: Bool = false, parent: RoutingNode? = nil, children: [RoutingNode] = []) {
        self.entry = entry
        self.isActive = isActive
        self.isManagedByParent = isManagedByParent
        self.parent = parent
        self.children = children
    }

    /// Adds children to the node
    ///
    /// - Parameter children: The nodes that should be added as children to the node
    func add(children: [RoutingNode]) {
        children.forEach { add(child: $0) }
    }

    /// Adds the given child to the node if does not exist yet
    ///
    /// - Parameter child: The node that should be added as a child
    func add(child: RoutingNode) {
        guard !children.contains(child) else { return }

        children.append(child)
        child.parent = self
    }

    /// Adds an active leaf to the node, i.e., it looks for the current active leaf and adds the given node
    /// as active child of the current active leaf
    ///
    /// - Parameter activeLeaf: The node that should be added as active leaf to the node
    func add(activeLeaf: RoutingNode) {
        let currentActiveLeaf = self.activeLeaf() ?? self
        currentActiveLeaf.isActive = true
        activeLeaf.isActive = true
        currentActiveLeaf.add(child: activeLeaf)
    }

    /// Removes the given node from the node's children. If the given node is not contained in the node's children
    /// this method does nothing
    ///
    /// - Parameter child: The child node that should be removed from the current node
    func remove(child: RoutingNode) {
        guard let index = children.firstIndex(where: { child == $0 }) else {
            print("[Routing Tree] Could not remove child with identifier: \(entry.identifier.rawValue)")
            return
        }

        children.remove(at: index)
    }

    /// Removes the current node by removing it from its parent's children
    func removeNode() {
        parent?.remove(child: self)
    }

    /// Determines the active path from the current node
    ///
    /// - Returns: A list of routing nodes representing the active path from the current node.
    /// If the current node is not active this method returns an empty path.
    func activePath() -> [RoutingNode] {
        guard isActive else { return [] }

        return [self] + (activeChild()?.activePath() ?? [])
    }

    /// Determines the active child of the node.
    ///
    /// - Returns: The first active child of the node if one exists, `nil` otherwise
    func activeChild() -> RoutingNode? {
        return children.first { $0.isActive }
    }

    /// Determines the active leaf of the node
    ///
    /// - Returns: The active leaf of the node if one exists, `nil` otherwise.
    func activeLeaf() -> RoutingNode? {
        guard isActive else { return nil }

        return activePath().last
    }

    /// Changes the active child of the node to the child associated with the given entry. If the given node is not
    /// contained within the current node's children this method does nothing.
    ///
    /// - Parameter entry: The entry that uniquely identifies the child that should become active
    func changeActiveChild(toNodeWithEntry entry: RoutingEntry) {
        guard children.firstIndex(where: { entry == $0.entry }) != nil else { // swiftlint:disable:this contains_over_first_not_nil
            print("[Routing Tree] Could not change active child to \(entry.identifier.rawValue)")
            return
        }

        children.forEach { $0.isActive = entry == $0.entry }
    }

    /// Recursively finds the first node that matches the given entry
    ///
    /// - Parameter entry: The entry of the node to seach for
    /// - Returns: The node for the given entry if it exists, `nil` otherwise
    func findNode(for entry: RoutingEntry) -> RoutingNode? {
        return find { $0.entry == entry }
    }

    /// Recursively finds the first node that satisfies the given predicate
    ///
    /// - Parameter isResult: The condition that must be satisfied by the result node
    /// - Returns: The first node satisfying the given predicate, `nil` otherwise
    func find(isResult: (RoutingNode) -> Bool) -> RoutingNode? {
        guard !isResult(self) else { return self }

        for child in children {
            let searchResult = child.find(isResult: isResult)
            if searchResult != nil {
                return searchResult
            }
        }

        return nil
    }
}

// MARK: - Equatable
extension RoutingNode: Equatable {
    /// Implementation of the `Equatable` protocol
    static func == (lhs: RoutingNode, rhs: RoutingNode) -> Bool {
        return lhs.entry == rhs.entry
    }
}

// MARK: - CustomStringConvertible
extension RoutingNode: CustomStringConvertible {
    // A textual description of the routing node
    var description: String {
        var description = "\(entry.identifier.rawValue)\(isActive ? "*" : "")"

        if let context = entry.context {
            description += " ("
            description += context.keys.compactMap { "\($0):\(context[$0] ?? "")" }.joined(separator: ", ")
            description += ")"
        }

        if !children.isEmpty {
            description += " ["
            description += children.map { $0.description }.joined(separator: ", ")
            description += "] "
        }

        return description
    }
}
