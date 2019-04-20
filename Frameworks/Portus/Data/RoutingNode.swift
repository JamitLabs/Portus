//
//  Created by Andreas Link on 10.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

class RoutingNode {
    var entry: RoutingEntry
    var isActive: Bool
    var parent: RoutingNode?
    private(set) var children: [RoutingNode]

    init(entry: RoutingEntry, isActive: Bool, parent: RoutingNode? = nil, children: [RoutingNode] = []) {
        self.entry = entry
        self.isActive = isActive
        self.parent = parent
        self.children = children
    }

    func add(child: RoutingNode) {
        children.append(child)
        child.parent = self
    }

    func add(children: [RoutingNode]) {
        children.forEach { add(child: $0) }
    }

    func add(activeLeaf: RoutingNode) {
        let currentActiveLeaf = self.activeLeaf() ?? self

        currentActiveLeaf.isActive = true
        activeLeaf.isActive = true

        currentActiveLeaf.add(child: activeLeaf)
    }

    func remove(child: RoutingNode) {
        guard let index = children.firstIndex(where: { child == $0 }) else {
            fatalError("[Routing Tree] Could not remove child with identifier: \(entry.identifier.rawValue)")
        }

        children.remove(at: index)
    }

    func removeNode() {
        parent?.remove(child: self)
    }

    func activePath() -> [RoutingNode] {
        guard isActive else { return [] }

        return [self] + (activeChild()?.activePath() ?? [])
    }

    func activeChild() -> RoutingNode? {
        return children.first { $0.isActive }
    }

    func activeLeaf() -> RoutingNode? {
        guard isActive else { return nil }

        return activePath().last
    }

    func changeActiveChild(toNodeWithEntry entry: RoutingEntry) {
        guard children.firstIndex(where: { entry == $0.entry }) != nil else {
            fatalError("[Routing Tree] Could not change active child to \(entry.identifier.rawValue)")
        }

        children.forEach { $0.isActive = entry == $0.entry }
    }

    func findNode(for entry: RoutingEntry) -> RoutingNode? {
        return find { $0.entry == entry }
    }

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

    func deepCopy() -> RoutingNode {
        var childrenCopies: [RoutingNode] = []

        let nodeCopy = RoutingNode(entry: entry, isActive: isActive, children: [])

        for child in children {
            let childCopy = child.deepCopy()
            childCopy.parent = nodeCopy
            childrenCopies.append(childCopy)
        }

        nodeCopy.children = childrenCopies

        return nodeCopy
    }
}

// MARK: - Equatable
extension RoutingNode: Equatable {
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
