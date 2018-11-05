//
//  Created by Andreas Link on 05.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public class Node {
    // MARK: - Properties
    var routingID: RoutingID
    var parentNode: Node?
    var subNodes: [Node]

    // MARK: - Initializers
    init(routingID: RoutingID, parentNode: Node? = nil, subNodes: [Node] = []) {
        self.routingID = routingID
        self.parentNode = parentNode
        self.subNodes = subNodes
    }

    // MARK: - Methods
    func removeSubNode(routingID: RoutingID) -> Bool {
        guard let indexToRemove = subNodes.firstIndex(where: { $0.routingID == routingID } ) else { return false }
        subNodes.remove(at: indexToRemove)
        return true
    }

    func searchNodeUsingDFS(routingID: RoutingID) -> Node? {
        guard self.routingID != routingID else { return self }
        for subNode in subNodes { if let node = subNode.searchNodeUsingDFS(routingID: routingID) { return node } }
        return nil
    }
}
