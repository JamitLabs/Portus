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
        isContainedInActivePath: Bool,
        parent: RoutingNode? = nil,
        children: [RoutingNode] = []
    ) {
        self.entry = entry
        self.isActive = isContainedInActivePath
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

    public func determineActiveChild() -> RoutingNode? {
        return children.first { $0.isActive }
    }

    public func determineActiveLeaf() -> RoutingNode? {
        guard isActive else { return nil }

        var activeLeaf = self
        while let localActiveLeaf = activeLeaf.determineActiveLeaf() {
            activeLeaf = localActiveLeaf
        }

        return activeLeaf
    }

    public func add(activeLeaf: RoutingNode) {
        let currentActiveLeaf = determineActiveLeaf() ?? self

        currentActiveLeaf.isActive = true
        activeLeaf.isActive = true

        currentActiveLeaf.add(child: activeLeaf)
    }

    internal func traverse(order: TraverseOrder, onNodeVisit: (RoutingNode) -> ()) {
        let sortedChildren = children.sorted { first, _ in !(first.isActive) }

        if order == .preOrder { onNodeVisit(self) }
        sortedChildren.forEach { $0.traverse(order: order, onNodeVisit: onNodeVisit) }
        if order == .postOrder { onNodeVisit(self) }
    }

    public func findNode(for entry: RoutingEntry) -> RoutingNode? {
        return find { $0.entry == entry }
    }

    public func find(isResult: (RoutingNode) -> Bool) -> RoutingNode?{
        guard !isResult(self) else { return self }

        return children.first { $0.find(isResult: isResult) != nil }
    }

    public func contains(entry: RoutingEntry) -> Bool {
        return find { $0.entry == entry } != nil ? true : false
    }

    public static func ==(lhs: RoutingNode, rhs: RoutingNode) -> Bool {
        return lhs.entry == rhs.entry
    }
}
