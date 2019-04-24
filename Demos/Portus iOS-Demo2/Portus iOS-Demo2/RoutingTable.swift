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
    static let root_FirstTab: StaticRoutingDestination = [.root, .firstTab].entries
    static let root_SecondTab: StaticRoutingDestination = [.root, .secondTab].entries
    static let root_ThirdTab: StaticRoutingDestination = [.root, .thirdTab].entries
    static let root_SecondTab_A_B_C_D_D: StaticRoutingDestination = [.root, .secondTab, .a, .b, .c, .d, .d].entries
    static let root_SecondTab_B_C_A_C_B_A: StaticRoutingDestination = [.root, .secondTab, .b, .c, .a, .c, .b, .a].entries
    static let root_ThirdTab_PageB_C_A_C: StaticRoutingDestination = [.root, .thirdTab, .pageB, .c, .a, .c].entries
    static let root_ThirdTab_PageA: StaticRoutingDestination = [.root, .thirdTab, .pageA].entries
    static let root_ThirdTab_PageB: StaticRoutingDestination = [.root, .thirdTab, .pageB].entries
    static let root_ThirdTab_PageC: StaticRoutingDestination = [.root, .thirdTab, .pageC].entries
}

extension RoutingTable.DynamicEntries {
    static let a: DynamicRoutingDestination = RoutingEntry(identifier: .a)
    static let b: DynamicRoutingDestination = RoutingEntry(identifier: .b)
    static let c: DynamicRoutingDestination = RoutingEntry(identifier: .c)
    static let d: DynamicRoutingDestination = RoutingEntry(identifier: .d)
}
