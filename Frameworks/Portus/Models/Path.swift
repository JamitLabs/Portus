//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public struct Path {
    // MARK: - Subtypes
    enum Identifier: String, Equatable {
        case startUp
        case flowA
        case flowB
    }

    var components: [Identifier]
    var firstComponent: Identifier? { return components.first }
    var remainingPath: Path { return Path(components: [Identifier](components.dropFirst())) }
}
