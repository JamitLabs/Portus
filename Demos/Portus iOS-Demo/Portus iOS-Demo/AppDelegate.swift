//
//  AppDelegate.swift
//  Portus iOS-Demo
//
//  Created by Cihat Gündüz on 22.10.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Imperio
import Portus
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var initialFlowCtrl: InitialFlowController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        Portus.window = window

        initialFlowCtrl = StartupFlowController()
        initialFlowCtrl?.start(from: window!)

        return true
    }
}
