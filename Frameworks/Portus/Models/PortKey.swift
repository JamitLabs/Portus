//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public typealias Route = [(enterableType: PortKeyEnterable.Type, info: Any?)]

public protocol PortKey {
    var route: Route { get }
}
