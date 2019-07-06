//
//  TabBarViewController.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 24.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            RoutingMenu.showMenu()
        }
    }
}
