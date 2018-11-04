//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

protocol Routable {
    var identifier: String { get }
    func dismiss()
    func dismissRecursively()
    func willDismiss(completion: (Bool) -> Void)
    func route(from origin: Path, to destination: Path)
}
