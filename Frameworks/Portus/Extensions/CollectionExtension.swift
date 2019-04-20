//
//  Created by Andreas Link on 07.04.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (try index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
