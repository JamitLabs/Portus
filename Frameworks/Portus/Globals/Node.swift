//
//  Created by Andreas Link on 05.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public class Node {
    var routingID: RoutingID
    var parentNode: Node?
    var subNodes: [Node]

    init(routingID: RoutingID, parentNode: Node? = nil, subNodes: [Node] = []) {
        self.routingID = routingID
        self.parentNode = parentNode
        self.subNodes = subNodes
    }

    func removeSubNode(with routingID: RoutingID) {
        guard let indexToRemove = subNodes.firstIndex(where: { $0.routingID == routingID } ) else { return }
        subNodes.remove(at: indexToRemove)
    }

    func getNodeWith(routingID: RoutingID) -> Node? {
        if routingID == routingID {
            return self
        } else {
            for subNode in subNodes { if let targetNode = subNode.getNodeWith(routingID: routingID) { return targetNode } }
        }

        return nil
    }
}
