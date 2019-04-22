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
    static let bookmarks = RoutingIdentifier(rawValue: "bookmarks")
}

class FirstTabViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
}

// MARK: - Routable
extension FirstTabViewController: Routable {
    var entry: RoutingEntry { return RoutingEntry(identifier: .bookmarks, routable: self) }
}

