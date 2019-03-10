//
//  Created by Andreas Link on 10.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public class RoutingNode {
    public var entry: RoutingEntry
    public var isContainedInActivePath: Bool
    public var parent: RoutingNode?
    public private(set) var children: [RoutingNode]

    public init(
        entry: RoutingEntry,
        isContainedInActivePath: Bool,
        parent: RoutingNode? = nil,
        children: [RoutingNode] = []
    ) {
        self.entry = entry
        self.isContainedInActivePath = isContainedInActivePath
        self.parent = parent
        self.children = children
    }

    public func addChild(_ child: RoutingNode) {
        children.append(child)
        child.parent = self
    }

    public func addChildren( _ children: [RoutingNode]) {
        children.forEach { addChild($0) }
    }

    public func removeChild(_ child: RoutingNode) {
        guard let index = children.firstIndex(where: { child == $0 }) else { return }

        children.remove(at: index)
    }

    public func removeNode() {
        parent?.removeChild(self)
    }

    public func determineActiveChild() -> RoutingNode? {
        return children.first { $0.isContainedInActivePath }
    }

    public func determineActiveLeaf() -> RoutingNode? {
        guard isContainedInActivePath else { return nil }

        var activeLeaf = self
        while let localActiveLeaf = activeLeaf.determineActiveLeaf() {
            activeLeaf = localActiveLeaf
        }

        return activeLeaf
    }

    public func addActiveLeaf(_ activeLeaf: RoutingNode) {
        let currentActiveLeaf = determineActiveLeaf() ?? self

        currentActiveLeaf.isContainedInActivePath = true
        activeLeaf.isContainedInActivePath = true

        currentActiveLeaf.addChild(activeLeaf)
    }

    public func traverse(postOrder: Bool, onNoteVisit: (RoutingNode) -> ()) {
        let sortedChildren = children.sorted { first, _ in !(first.isContainedInActivePath) }

        if !postOrder { onNoteVisit(self) }
        sortedChildren.forEach { $0.traverse(postOrder: postOrder, onNoteVisit: onNoteVisit) }
        if postOrder { onNoteVisit(self) }
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
