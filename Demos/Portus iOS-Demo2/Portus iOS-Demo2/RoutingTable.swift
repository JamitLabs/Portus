//
//  RoutingTable.swift
//  Portus iOS-Demo2
//
//  Created by Andreas Link on 22.04.19.
//  Copyright © 2019 Andreas Link. All rights reserved.
//

import Foundation
import Portus

extension RoutingTable.StaticEntries {
    static let destination1: StaticRoutingDestination = [.root, .secondTab, .b, .c, .a, .c, .b, .a].entries
    static let destination2: StaticRoutingDestination = [.root, .favorites, .pageB, .c, .a, .c].entries
}

extension RoutingTable.DynamicEntries {
    static let a: DynamicRoutingDestination = RoutingEntry(identifier: .a)
    static let b: DynamicRoutingDestination = RoutingEntry(identifier: .b)
    static let c: DynamicRoutingDestination = RoutingEntry(identifier: .c)
    static let d: DynamicRoutingDestination = RoutingEntry(identifier: .d)
}
