//
//  Portus.swift
//  Portus iOS-Demo
//
//  Created by Cihat Gündüz on 19.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation
import Portus

struct RoutingTableEntry {
    var identifier: RoutingIdentifier
    var info: Any?
    var reachableEntries: [RoutingTableEntry]

    init(identifier: RoutingIdentifier, info: Any? = nil, reachableEntries: [RoutingTableEntry] = []) {
        self.identifier = identifier
        self.info = info
        self.reachableEntries = reachableEntries
    }
}

enum RoutingTable {
    static let A = ["Root", "A"]
    static let B = ["Root", "B"]
    static let AB = ["Root", "A", "B"]
    static let BA = ["Root", "B", "A"]

    static let root: RoutingTableEntry = RoutingTableEntry(
        identifier: "Root",
        reachableEntries: [
            RoutingTableEntry(
                identifier: "A",
                reachableEntries: [
                    RoutingTableEntry(identifier: "B")
                ]
            ),
            RoutingTableEntry(
                identifier: "B",
                reachableEntries: [
                    RoutingTableEntry(identifier: "A")
                ]
            )
        ]
    )
}
