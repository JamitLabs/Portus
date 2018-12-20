//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit

public protocol PortKeyLeavable: class {
    var visibleViewController: UIViewController { get }

    func leave(animated: Bool, completion: @escaping () -> Void)
}
