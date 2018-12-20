//
//  Created by Cihat Gündüz on 20.12.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit

public protocol PortKeyEnterable: PortKeyLeavable {
    static var routingId: String { get }

    static func enter(from presentingViewController: UIViewController, info: Any?, animated: Bool, completion: @escaping (UIViewController) -> Void)
}

extension PortKeyEnterable {
    public static var routingId: String { return String(describing: Self.self) }
}
