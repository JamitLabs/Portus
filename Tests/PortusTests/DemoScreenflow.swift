// swiftlint:disable:this file_name
//
//  Created by Andreas Link on 21.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation
import Portus

extension RoutingIdentifier {
    static let node1 = RoutingIdentifier(rawValue: "node1")
    static let node2 = RoutingIdentifier(rawValue: "node2")
    static let node3 = RoutingIdentifier(rawValue: "node3")
    static let node4 = RoutingIdentifier(rawValue: "node4")
    static let node5 = RoutingIdentifier(rawValue: "node5")
    static let node6 = RoutingIdentifier(rawValue: "node6")
    static let node7 = RoutingIdentifier(rawValue: "node7")
    static let node8 = RoutingIdentifier(rawValue: "node8")
    static let node9 = RoutingIdentifier(rawValue: "node9")
    static let node10 = RoutingIdentifier(rawValue: "node10")
    static let node11 = RoutingIdentifier(rawValue: "node11")
    static let node12 = RoutingIdentifier(rawValue: "node12")
    static let node13 = RoutingIdentifier(rawValue: "node13")

    static let switchNode1 = RoutingIdentifier(rawValue: "switchNode1")
    static let switchNode2 = RoutingIdentifier(rawValue: "switchNode2")
    static let switchNode3 = RoutingIdentifier(rawValue: "switchNode3")
}

class SwitchNode1: Switchable {
    private var started: Bool = false
    var entry: RoutingEntry {
        return RoutingEntry(
            identifier: .switchNode1,
            routable: self,
            managedEntries: RoutingEntry.ManagedEntries(
                entries: [switchNode2.entry, node1.entry, node2.entry],
                activeEntry: node1.entry
            )
        )
    }

    private lazy var switchNode2 = SwitchNode2()
    private lazy var node1 = Node1()
    private lazy var node2 = Node2()

    func startIfNeeded() {
        guard !started else { return }

        started = true
        RoutingTree.default.didEnterNode(withEntry: entry)
    }

    func switchToNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .switchNode2:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: switchNode2.entry)
            switchNode2.startIfNeeded()
            completion(true)

        case .node1:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: node1.entry)
            completion(true)

        case .node2:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: node2.entry)
            completion(true)

        default:
            completion(false)
        }
    }
}

class SwitchNode2: Switchable {
    private var started: Bool = false
    var entry: RoutingEntry {
        return RoutingEntry(
            identifier: .switchNode2,
            routable: self,
            managedEntries: RoutingEntry.ManagedEntries(
                entries: [node3.entry, node4.entry],
                activeEntry: node3.entry
            )
        )
    }

    private lazy var node3 = NonLeavableLeafNode(identifier: .node3)
    private lazy var node4 = NonLeavableLeafNode(identifier: .node4)

    func startIfNeeded() {
        guard !started else { return }

        started = true
        RoutingTree.default.didEnterNode(withEntry: entry)
    }

    func switchToNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .node3:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: node3.entry)
            completion(true)

        case .node4:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: node4.entry)
            completion(true)

        default:
            completion(false)
        }
    }
}

class SwitchNode3: Switchable, Leavable {
    private var started: Bool = false
    var entry: RoutingEntry {
        return RoutingEntry(
            identifier: .switchNode3,
            routable: self,
            managedEntries: RoutingEntry.ManagedEntries(
                entries: [node12.entry, node13.entry],
                activeEntry: node13.entry
            )
        )
    }

    private lazy var node12 = NonLeavableLeafNode(identifier: .node12)
    private lazy var node13 = NonLeavableLeafNode(identifier: .node13)

    func startIfNeeded() {
        guard !started else { return }

        started = true
        RoutingTree.default.didEnterNode(withEntry: entry)
    }

    func switchToNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .node12:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: node12.entry)
            completion(true)

        case .node13:
            RoutingTree.default.switchNode(withEntry: self.entry, didSwitchToNodeWithEntry: node13.entry)
            completion(true)

        default:
            completion(false)
        }
    }

    func leaveNode(with entry: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void) {
        guard entry == self.entry else { return completion(false) }

        RoutingTree.default.didLeaveNode(with: self.entry)
        completion(true)
    }

    func canLeaveNode(with entry: RoutingEntry) -> Bool {
        return entry == self.entry
    }
}

class LeafNode: Leavable {
    let identifier: RoutingIdentifier

    var entry: RoutingEntry { return RoutingEntry(identifier: identifier, routable: self) }

    init(identifier: RoutingIdentifier) {
        self.identifier = identifier
    }

    func leaveNode(with entry: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void) {
        guard entry == self.entry else { return completion(false) }

        RoutingTree.default.didLeaveNode(with: self.entry)
        completion(true)
    }

    func canLeaveNode(with entry: RoutingEntry) -> Bool {
        return entry == self.entry
    }
}

class NonLeavableLeafNode: Routable {
    let identifier: RoutingIdentifier

    var entry: RoutingEntry { return RoutingEntry(identifier: identifier, routable: self) }

    init(identifier: RoutingIdentifier) {
        self.identifier = identifier
    }
}

class Node1: Enterable {
    var entry: RoutingEntry { return RoutingEntry(identifier: .node1, routable: self) }

    private lazy var node5 = Node5()
    private lazy var node6 = Node6()

    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .node5:
            RoutingTree.default.didEnterNode(withEntry: node5.entry)
            completion(true)

        case .node6:
            RoutingTree.default.didEnterNode(withEntry: node6.entry)
            completion(true)

        default:
            completion(false)
        }
    }
}

class Node2: Enterable {
    var entry: RoutingEntry { return RoutingEntry(identifier: .node2, routable: self) }

    private lazy var node7 = LeafNode(identifier: .node7)

    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .node7:
            RoutingTree.default.didEnterNode(withEntry: node7.entry)
            completion(true)

        case .switchNode3:
            let switchNode3 = SwitchNode3()
            switchNode3.startIfNeeded()
            completion(true)

        default:
            completion(false)
        }
    }
}

class Node5: Enterable, Leavable {
    var entry: RoutingEntry { return RoutingEntry(identifier: .node5, routable: self) }

    private lazy var node8 = LeafNode(identifier: .node8)
    private lazy var node9 = LeafNode(identifier: .node9)
    private lazy var node10 = LeafNode(identifier: .node10)

    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .node8:
            RoutingTree.default.didEnterNode(withEntry: node8.entry)
            completion(true)

        case .node9:
            RoutingTree.default.didEnterNode(withEntry: node9.entry)
            completion(true)

        case .node10:
            RoutingTree.default.didEnterNode(withEntry: node10.entry)
            completion(true)

        default:
            completion(false)
        }
    }

    func leaveNode(with entry: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void) {
        guard entry == self.entry else { return completion(false) }

        RoutingTree.default.didLeaveNode(with: self.entry)
        completion(true)
    }

    func canLeaveNode(with entry: RoutingEntry) -> Bool {
        return entry == self.entry
    }
}

class Node6: Enterable, Leavable {
    var entry: RoutingEntry { return RoutingEntry(identifier: .node6, routable: self) }

    private lazy var node11 = LeafNode(identifier: .node11)

    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .node11:
            RoutingTree.default.didEnterNode(withEntry: node11.entry)
            completion(true)

        default:
            completion(false)
        }
    }

    func leaveNode(with entry: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void) {
        guard entry == self.entry else { return completion(false) }

        RoutingTree.default.didLeaveNode(with: self.entry)
        completion(true)
    }

    func canLeaveNode(with entry: RoutingEntry) -> Bool {
        return entry == self.entry
    }
}
