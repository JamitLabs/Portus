//
//  DelegatesManager.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation
import Portus

class DelegatesManager {
    // MARK: - Properties
    static let shared = DelegatesManager()
    weak var router: Routable?

    // MARK: - Initializers
    private init() {}
}
