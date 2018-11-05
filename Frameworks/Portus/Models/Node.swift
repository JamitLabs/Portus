//
//  Created by Andreas Link on 05.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public class Node {
    // MARK: - Properties
    var routableID: RoutableID
    var parentNode: Node?
    var subNodes: [Node]

    // MARK: - Initializers
    init(routableID: RoutableID, parentNode: Node? = nil, subNodes: [Node] = []) {
        self.routableID = routableID
        self.parentNode = parentNode
        self.subNodes = subNodes
    }

    // MARK: - Methods
    @discardableResult
    func removeSubNode(routableID: RoutableID) -> Bool {
        guard let indexToRemove = subNodes.firstIndex(where: { $0.routableID == routableID }) else { return false }
        subNodes.remove(at: indexToRemove)
        return true
    }

    func nodeUsingDFS(routableID: RoutableID) -> Node? {
        guard self.routableID != routableID else { return self }
        for subNode in subNodes {
            guard let node = subNode.nodeUsingDFS(routableID: routableID) else { continue }
            return node
        }

        return nil
    }
}
