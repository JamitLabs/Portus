//
//  RoutingMenuViewController.swift
//  Portus iOS-Demo2
//
//  Created by Andreas Link on 24.04.19.
//  Copyright © 2019 Andreas Link. All rights reserved.
//

import Portus
import UIKit

class RoutingMenu {
    static func showMenu() {
        let alert = UIAlertController(title: "Routing Menu", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Root->FirstTab", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.root_FirstTab)
        }))
        alert.addAction(UIAlertAction(title: "Root->SecondTab", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.root_SecondTab)
        }))
        alert.addAction(UIAlertAction(title: "Root->ThirdTab->PageA", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.root_ThirdTab_PageA)
        }))
        alert.addAction(UIAlertAction(title: "Root->ThirdTab->PageB", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.root_ThirdTab_PageB)
        }))
        alert.addAction(UIAlertAction(title: "Root->ThirdTab->PageC", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.root_ThirdTab_PageC)
        }))
        alert.addAction(UIAlertAction(title: "Root->SecondTab->A->B->C->D->D", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.root_SecondTab_A_B_C_D_D)
        }))
        alert.addAction(UIAlertAction(title: "Root->ThirdTab->PageB->C->A->C", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.root_ThirdTab_PageB_C_A_C)
        }))
        alert.addAction(UIAlertAction(title: "Root->SecondTab->B->C->A->C->B->A", style: .default, handler: { _ in
            Router.default.routeTo(staticDestination: RoutingTable.StaticEntries.root_SecondTab_B_C_A_C_B_A)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))

        UIApplication.topViewController()?.present(alert, animated: true)
    }
}
