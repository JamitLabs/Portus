//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation
import Imperio

public protocol Routable: class {
    var identifier: Path.Identifier { get }
    var parent: Routable? { get set }
    var children: [Routable] { get set }

    func currentPath() -> Path
    func route(from origin: Path, to destination: Path)
    func willDismiss(completion: @escaping () -> Void)
    func dismiss(animated: Bool, completion: @escaping () -> Void)
    func open(_ routable: Routable, animated: Bool, completion: @escaping () -> Void)
}

extension Routable { // swiftlint:disable:this extension_access_modifier
    public func willDismiss(completion: @escaping () -> Void) {
        completion()
    }

    public func route(from origin: Path, to destination: Path) {
        switch (origin.firstComponent, destination.firstComponent) {
        case (_, .none):
            // Reached the desired location
            return

        case let (.none, secondId?):
            open(secondId, animated: false) {
                second.routable.route(from: origin.remainingPath, to: destination.remainingPath)
            }

        case let (firstId?, secondId?):
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

    public func currentPath() -> Path {
        if let parent = parent {
            return Path(components: parent.currentPath().components + [PathComponent(identifier: identifier)])
        } else {
            return Path(components: [PathComponent(identifier: identifier)])
        }
    }
}
