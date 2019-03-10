//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

public struct RoutingId: RawRepresentable, Equatable, Hashable {
    public typealias RawValue = String
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
