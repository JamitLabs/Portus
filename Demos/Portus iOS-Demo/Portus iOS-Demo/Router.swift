//
//  Portus.swift
//  Portus iOS-Demo
//
//  Created by Cihat Gündüz on 19.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation
import Portus

enum Router {
    case flowA
}

extension Router: Destination {
    var location: [Enterable] {
        
    }
}
