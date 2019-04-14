//
//  Created by Andreas Link on 10.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public class RoutingNode {
    enum TraverseOrder {
        case preOrder
        case postOrder
    }

    public var entry: RoutingEntry
    public var isActive: Bool
    public var parent: RoutingNode?
    public private(set) var children: [RoutingNode]

    public init(
        entry: RoutingEntry,
        isActive: Bool,
        parent: RoutingNode? = nil,
        children: [RoutingNode] = []
    ) {
        self.entry = entry
        self.isActive = isActive
        self.parent = parent
        self.children = children
    }

    public func add(child: RoutingNode) {
        children.append(child)
        child.parent = self
    }

    public func add(children: [RoutingNode]) {
        children.forEach { add(child: $0) }
    }

    public func remove(child: RoutingNode) {
        guard let index = children.firstIndex(where: { child == $0 }) else { return }

        children.remove(at: index)
    }

    public func removeNode() {
        parent?.remove(child: self)
    }

    public func activePath() -> [RoutingNode] {
        guard isActive else { return [] }

        return [self] + (determineActiveChild()?.activePath() ?? [])
    }

    public func determineActiveChild() -> RoutingNode? {
        return children.first { $0.isActive }
    }

    public func determineActiveLeaf() -> RoutingNode? {
        guard isActive else { return nil }

        return activePath().last
    }

    public func changeActiveChild(toNodeWith entry: RoutingEntry) {
        guard children.firstIndex(where: { entry == $0.entry }) != nil else {
            fatalError("[Routing Tree] Could not change active Child of \(self.entry.identifier.rawValue) to \(entry.identifier.rawValue)") }

        children.forEach { $0.isActive = entry == $0.entry }
    }

    public func add(activeLeaf: RoutingNode) {
        let currentActiveLeaf = determineActiveLeaf() ?? self

        currentActiveLeaf.isActive = true
        activeLeaf.isActive = true

        currentActiveLeaf.add(child: activeLeaf)
    }

    internal func traverse(order: TraverseOrder, onNodeVisit: (RoutingNode) -> Void) {
        let sortedChildren = children.sorted { first, _ in !(first.isActive) }

        if order == .preOrder { onNodeVisit(self) }
        sortedChildren.forEach { $0.traverse(order: order, onNodeVisit: onNodeVisit) }
        if order == .postOrder { onNodeVisit(self) }
    }

    public func findNode(for entry: RoutingEntry) -> RoutingNode? {
        return find { $0.entry == entry }
    }

    public func find(isResult: (RoutingNode) -> Bool) -> RoutingNode? {
        guard !isResult(self) else { return self }

        for child in children {
            let searchResult = child.find(isResult: isResult)
            if searchResult != nil {
                return searchResult
            }
        }

        return nil
    }

    public func contains(entry: RoutingEntry) -> Bool {
        return find { $0.entry == entry } != nil ? true : false
    }

    public static func == (lhs: RoutingNode, rhs: RoutingNode) -> Bool {
        return lhs.entry == rhs.entry
    }

    public func deepCopy() -> RoutingNode {
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

// MARK: - CustomStringConvertible
extension RoutingNode: CustomStringConvertible {
    public var description: String {
        var description = "\(entry.identifier.rawValue)\(isActive ? "*" : "")"

        if let context = entry.context {
            description += " (" + context.keys.compactMap { key in "\(key):\(String(describing: context[key]))" }.joined(separator: ", ") + ")"
        }

        if !children.isEmpty {
            description += " [" + children.map { $0.description }.joined(separator: ", ") + "] "
        }

        return description
    }
}
