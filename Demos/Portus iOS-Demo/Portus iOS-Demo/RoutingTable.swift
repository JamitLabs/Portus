//
//  Portus.swift
//  Portus iOS-Demo
//
//  Created by Cihat Gündüz on 19.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation
import Portus

enum RoutingTable {
    static let A = [
        RoutingIdentifiers.root,
        RoutingIdentifiers.A
    ]

    static let B = [
        RoutingIdentifiers.root,
        RoutingIdentifiers.B
    ]

    static let AB = [
        RoutingIdentifiers.root,
        RoutingIdentifiers.A,
        RoutingIdentifiers.B
    ]

    static let BA = [
        RoutingIdentifiers.root,
        RoutingIdentifiers.B,
        RoutingIdentifiers.A
    ]
}
