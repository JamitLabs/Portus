//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public protocol Routable: class {
    var routingID: RoutingID { get }

    func route(from origin: Path, to destination: Path)
    func willDismiss(completion: @escaping () -> Void)
    func dismiss(animated: Bool, completion: @escaping () -> Void)
    func open(_ routable: Routable, animated: Bool, completion: @escaping () -> Void)
}

extension Routable { // swiftlint:disable:this extension_access_modifier
    public func route(from origin: Path, to destination: Path) {
        switch (origin.firstPathComponent, destination.firstPathComponent) {
        case (_, .none):
            // Reached the desired location
            return

        case let (.none, second?):
            open(second, animated: false) {
                second.routable.route(from: origin.remainingPath, to: destination.remainingPath)
            }

        case let (first?, second?):
            if first == second {
                second.routable.route(from: origin.remainingPath, to: destination.remainingPath)
            } else {
                first.routable.willDismiss {
                    first.routable.dismiss(animated: false) { [weak self] in
                        self?.open(second.routable, animated: false) {
                            second.routable.route(from: origin.remainingPath, to: destination.remainingPath)
                        }
                    }
                }
            }
        }
    }

    public func willDismiss(completion: @escaping () -> Void) {
        completion()
    }
}
