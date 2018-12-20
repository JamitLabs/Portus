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
    case flowB
    case flowAB
    case flowBA
}

extension Router: PortKey {
    var route: Route {
        switch self {
        case .flowA:
            return [(FlowAFlowController.self, nil)]

        case .flowB:
            return [(FlowBFlowController.self, nil)]

        case .flowAB:
            return [
                (FlowAFlowController.self, nil),
                (FlowBFlowController.self, nil)
            ]

        case .flowBA:
            return [
                (FlowBFlowController.self, nil),
                (FlowAFlowController.self, nil)
            ]
        }
    }
}
