//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

typealias Route = [(routingId: String, enteringData: Any?)] // TODO: replace routingId with enterable type

protocol PortKey {
    var route: Route { get }
}
