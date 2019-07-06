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
    static let colorList = [.root, .colorList].entries
    static let bookmarks = [.root, .bookmarks].entries

    static func colorDetail(withHexString hexString: String) -> [RoutingEntry] {
        return [
            RoutingEntry(identifier: .root),
            RoutingEntry(identifier: .colorList),
            RoutingEntry(identifier: .colorDetail, context: ["hex": "\(hexString)"])
        ]
    }

    static let a = [.root, .bookmarks, .a].entries
    static let b = [.root, .bookmarks, .b].entries
    static let c = [.root, .bookmarks, .c].entries

    static let aa = [.root, .bookmarks, .a, .a].entries
    static let ab = [.root, .bookmarks, .a, .b].entries
    static let ac = [.root, .bookmarks, .a, .c].entries
    static let ba = [.root, .bookmarks, .b, .a].entries
    static let bb = [.root, .bookmarks, .b, .b].entries
    static let bc = [.root, .bookmarks, .b, .c].entries
    static let ca = [.root, .bookmarks, .c, .a].entries
    static let cb = [.root, .bookmarks, .c, .b].entries
    static let cc = [.root, .bookmarks, .c, .c].entries

    static let aaa = [.root, .bookmarks, .a, .a, .a].entries
    static let aab = [.root, .bookmarks, .a, .a, .b].entries
    static let aac = [.root, .bookmarks, .a, .a, .c].entries
    static let aba = [.root, .bookmarks, .a, .b, .a].entries
    static let abb = [.root, .bookmarks, .a, .b, .b].entries
    static let abc = [.root, .bookmarks, .a, .b, .c].entries
    static let aca = [.root, .bookmarks, .a, .c, .a].entries
    static let acb = [.root, .bookmarks, .a, .c, .b].entries
    static let acc = [.root, .bookmarks, .a, .c, .c].entries

    static let baa = [.root, .bookmarks, .b, .a, .a].entries
    static let bab = [.root, .bookmarks, .b, .a, .b].entries
    static let bac = [.root, .bookmarks, .b, .a, .c].entries
    static let bba = [.root, .bookmarks, .b, .b, .a].entries
    static let bbb = [.root, .bookmarks, .b, .b, .b].entries
    static let bbc = [.root, .bookmarks, .b, .b, .c].entries
    static let bca = [.root, .bookmarks, .b, .c, .a].entries
    static let bcb = [.root, .bookmarks, .b, .c, .b].entries
    static let bcc = [.root, .bookmarks, .b, .c, .c].entries

    static let caa = [.root, .bookmarks, .c, .a, .a].entries
    static let cab = [.root, .bookmarks, .c, .a, .b].entries
    static let cac = [.root, .bookmarks, .c, .a, .c].entries
    static let cba = [.root, .bookmarks, .c, .b, .a].entries
    static let cbb = [.root, .bookmarks, .c, .b, .b].entries
    static let cbc = [.root, .bookmarks, .c, .b, .c].entries
    static let cca = [.root, .bookmarks, .c, .c, .a].entries
    static let ccb = [.root, .bookmarks, .c, .c, .b].entries
    static let ccc = [.root, .bookmarks, .c, .c, .c].entries

    static let abcaabbcc = [.root, .bookmarks, .a, .b, .c, .a, .a, .b, .b, .c, .c].entries
    static let cabbc = [.root, .bookmarks, .c, .a, .b, .b, .c].entries
}

// Dynamic Routing Destinations
extension RoutingTable.DynamicEntries {
    static let a = RoutingEntry(identifier: .a)
    static let b = RoutingEntry(identifier: .b)
    static let c = RoutingEntry(identifier: .c)
}
