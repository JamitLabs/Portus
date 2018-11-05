//
//  Created by Andreas Link on 04.11.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Foundation

public protocol Routable: class {
    // MARK: - Properties
    var routableID: RoutableID { get }

    // MARK: - Methods
    func willDismiss(completion: @escaping () -> Void)
    func dismiss(animated: Bool, completion: @escaping () -> Void)
    func open(_ routingID: RoutableID, animated: Bool, completion: @escaping (Routable?) -> Void)
    func route(from origin: Path, to destination: Path)
}

extension Routable {
    // MARK: - Properties
    var routableID: RoutableID { return String(describing: self) }

    // MARK: - Methods
    public func willDismiss(completion: @escaping () -> Void) { completion() }

    public func route(from origin: Path, to destination: Path) {
        switch (origin.nextPathComponent, destination.nextPathComponent) {
        case (_, .none):
            return // NOTE: We are already at the desired location

        case let (.none, secondID?):
            open(secondID, animated: false) { [weak self] routable in
                guard let self = self, let routable = routable else { return }
                RoutingTree.shared.add(routable: routable, parent: self)
                routable.route(from: origin.remainingPath, to: destination.remainingPath)
            }

        case let (firstID?, secondID?):
            guard let currentRoutable = RoutingTree.shared.getRoutableWith(identifier: firstID) else { return }

            if firstID == secondID {
                currentRoutable.route(from: origin.remainingPath, to: destination.remainingPath)
            } else {
                currentRoutable.willDismiss {
                    currentRoutable.dismiss(animated: false) { [weak self] in
                        guard let self = self else { return }
                        self.open(secondID, animated: false) { [weak self] routable in
                            guard let self = self, let routable = routable else { return }
                            RoutingTree.shared.add(routable: routable, parent: self)
                            routable.route(from: origin.remainingPath, to: destination.remainingPath)
                        }
                    }
                }
            }
        }
    }
}
