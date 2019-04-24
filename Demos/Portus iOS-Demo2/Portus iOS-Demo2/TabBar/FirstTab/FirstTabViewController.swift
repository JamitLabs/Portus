//
//  FirstTabViewController.swift
//  Portus iOS-Demo2
//
//  Created by Andreas Link on 22.04.19.
//  Copyright © 2019 Andreas Link. All rights reserved.
//

import Portus
import UIKit

extension RoutingIdentifier {
    static let firstTab = RoutingIdentifier(rawValue: "firstTab")
}

class FirstTabViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
}

// MARK: - Routable
extension FirstTabViewController: Routable {
    var entry: RoutingEntry { return RoutingEntry(identifier: .firstTab, routable: self) }
}

