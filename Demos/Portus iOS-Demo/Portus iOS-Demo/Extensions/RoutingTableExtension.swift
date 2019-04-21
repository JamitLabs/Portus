//
//  Portus.swift
//  Portus iOS-Demo
//
//  Created by Cihat Gündüz on 19.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation
import Portus

// MARK: - Static Routes
extension RoutingTable.StaticEntries {
    static let colorList = [.root, .cl].entries
    static let bookmarks = [.root, .bm].entries

    static func colorDetail(withHexString hexString: String) -> [RoutingEntry] {
        return [
            RoutingEntry(identifier: .root),
            RoutingEntry(identifier: .cl),
            RoutingEntry(identifier: .colorDetail, context: ["hex": "\(hexString)"])
        ]
    }

    static let a = [.root, .bm, .a].entries
    static let b = [.root, .bm, .b].entries
    static let c = [.root, .bm, .c].entries

    static let aa = [.root, .bm, .a, .a].entries
    static let ab = [.root, .bm, .a, .b].entries
    static let ac = [.root, .bm, .a, .c].entries
    static let ba = [.root, .bm, .b, .a].entries
    static let bb = [.root, .bm, .b, .b].entries
    static let bc = [.root, .bm, .b, .c].entries
    static let ca = [.root, .bm, .c, .a].entries
    static let cb = [.root, .bm, .c, .b].entries
    static let cc = [.root, .bm, .c, .c].entries

    static let aaa = [.root, .bm, .a, .a, .a].entries
    static let aab = [.root, .bm, .a, .a, .b].entries
    static let aac = [.root, .bm, .a, .a, .c].entries
    static let aba = [.root, .bm, .a, .b, .a].entries
    static let abb = [.root, .bm, .a, .b, .b].entries
    static let abc = [.root, .bm, .a, .b, .c].entries
    static let aca = [.root, .bm, .a, .c, .a].entries
    static let acb = [.root, .bm, .a, .c, .b].entries
    static let acc = [.root, .bm, .a, .c, .c].entries

    static let baa = [.root, .bm, .b, .a, .a].entries
    static let bab = [.root, .bm, .b, .a, .b].entries
    static let bac = [.root, .bm, .b, .a, .c].entries
    static let bba = [.root, .bm, .b, .b, .a].entries
    static let bbb = [.root, .bm, .b, .b, .b].entries
    static let bbc = [.root, .bm, .b, .b, .c].entries
    static let bca = [.root, .bm, .b, .c, .a].entries
    static let bcb = [.root, .bm, .b, .c, .b].entries
    static let bcc = [.root, .bm, .b, .c, .c].entries

    static let caa = [.root, .bm, .c, .a, .a].entries
    static let cab = [.root, .bm, .c, .a, .b].entries
    static let cac = [.root, .bm, .c, .a, .c].entries
    static let cba = [.root, .bm, .c, .b, .a].entries
    static let cbb = [.root, .bm, .c, .b, .b].entries
    static let cbc = [.root, .bm, .c, .b, .c].entries
    static let cca = [.root, .bm, .c, .c, .a].entries
    static let ccb = [.root, .bm, .c, .c, .b].entries
    static let ccc = [.root, .bm, .c, .c, .c].entries
}

// Dynamic Routing Destinations
extension RoutingTable.DynamicEntries {
    static let a = RoutingEntry(identifier: .a)
    static let b = RoutingEntry(identifier: .b)
    static let c = RoutingEntry(identifier: .c)
}
