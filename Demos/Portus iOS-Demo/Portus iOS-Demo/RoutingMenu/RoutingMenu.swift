//
//  RoutingMenu.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 24.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Portus
import UIKit

class RoutingMenu {
    static func showMenu() {
        let alert = UIAlertController(title: "Routing Menu", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Root->ColorList", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.colorList)
        }))
        alert.addAction(UIAlertAction(title: "Root->ColorList->ColorDetail[#6B656C]", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.colorDetail(withHexString: "#6B656C"))
        }))
        alert.addAction(UIAlertAction(title: "Root->ColorList->ColorDetail[#AB41C0]", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.colorDetail(withHexString: "#AB41C0"))
        }))
        alert.addAction(UIAlertAction(title: "Root->Bookmarks", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.bookmarks)
        }))
        alert.addAction(UIAlertAction(title: "Root->Bookmarks->C->A->B->B->C", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.cabbc)
        }))
        alert.addAction(UIAlertAction(title: "Root->Bookmarks->A->B->C->A->A->B->B->C->C", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.abcaabbcc)
        }))
        alert.addAction(UIAlertAction(title: "Root->Bookmarks->A->B->A", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.aba)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))

        UIApplication.topViewController()?.present(alert, animated: true)
    }
}
