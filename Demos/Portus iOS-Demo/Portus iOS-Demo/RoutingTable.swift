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
    enum Static {
        static let colorList = [.root, .colorList].nodes
        static func colorDetail(withHexString hexString: String) -> [Node] {
            return [
                Node(identifier: .root),
                Node(identifier: .colorList),
                Node(identifier: .colorDetail, parameters: ["hex": "\(hexString)"])
            ]
        }

        static let bookmarks = [.root, .bookmarks].nodes
        static let a = [.root, .bookmarks, .a].nodes
        static let b = [.root, .bookmarks, .b].nodes
        static let c = [.root, .bookmarks, .c].nodes

        static let aa = [.root, .bookmarks, .a, .a].nodes
        static let ab = [.root, .bookmarks, .a, .b].nodes
        static let ac = [.root, .bookmarks, .a, .c].nodes
        static let ba = [.root, .bookmarks, .b, .a].nodes
        static let bb = [.root, .bookmarks, .b, .b].nodes
        static let bc = [.root, .bookmarks, .b, .c].nodes
        static let ca = [.root, .bookmarks, .c, .a].nodes
        static let cb = [.root, .bookmarks, .c, .b].nodes
        static let cc = [.root, .bookmarks, .c, .c].nodes

        static let aaa = [.root, .bookmarks, .a, .a, .a].nodes
        static let aab = [.root, .bookmarks, .a, .a, .b].nodes
        static let aac = [.root, .bookmarks, .a, .a, .c].nodes
        static let aba = [.root, .bookmarks, .a, .b, .a].nodes
        static let abb = [.root, .bookmarks, .a, .b, .b].nodes
        static let abc = [.root, .bookmarks, .a, .b, .c].nodes
        static let aca = [.root, .bookmarks, .a, .c, .a].nodes
        static let acb = [.root, .bookmarks, .a, .c, .b].nodes
        static let acc = [.root, .bookmarks, .a, .c, .c].nodes

        static let baa = [.root, .bookmarks, .b, .a, .a].nodes
        static let bab = [.root, .bookmarks, .b, .a, .b].nodes
        static let bac = [.root, .bookmarks, .b, .a, .c].nodes
        static let bba = [.root, .bookmarks, .b, .b, .a].nodes
        static let bbb = [.root, .bookmarks, .b, .b, .b].nodes
        static let bbc = [.root, .bookmarks, .b, .b, .c].nodes
        static let bca = [.root, .bookmarks, .b, .c, .a].nodes
        static let bcb = [.root, .bookmarks, .b, .c, .b].nodes
        static let bcc = [.root, .bookmarks, .b, .c, .c].nodes

        static let caa = [.root, .bookmarks, .c, .a, .a].nodes
        static let cab = [.root, .bookmarks, .c, .a, .b].nodes
        static let cac = [.root, .bookmarks, .c, .a, .c].nodes
        static let cba = [.root, .bookmarks, .c, .b, .a].nodes
        static let cbb = [.root, .bookmarks, .c, .b, .b].nodes
        static let cbc = [.root, .bookmarks, .c, .b, .c].nodes
        static let cca = [.root, .bookmarks, .c, .c, .a].nodes
        static let ccb = [.root, .bookmarks, .c, .c, .b].nodes
        static let ccc = [.root, .bookmarks, .c, .c, .c].nodes
    }

    enum Dynamic {
        static let a = Node(identifier: .a)
        static let b = Node(identifier: .b)
        static let c = Node(identifier: .c)
    }
}
