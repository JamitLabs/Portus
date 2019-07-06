//
//  ViewControllerA.swift
//  Portus iOS-Demo2
//
//  Created by Andreas Link on 22.04.19.
//  Copyright © 2019 Andreas Link. All rights reserved.
//

import Portus
import UIKit

extension RoutingIdentifier {
    static let a = RoutingIdentifier(rawValue: "a")
}

class ViewControllerA: UIViewController {
    @IBAction func buttonTriggered(_ sender: Any) {
        guard let title = (sender as? UIButton)?.titleLabel?.text else { return }

        Router.default.enter(dynamicDestination: RoutingEntry(identifier: RoutingIdentifier(rawValue: title)))
    }
}

// MARK: - Routable
extension ViewControllerA: Routable {
    var entry: RoutingEntry { return RoutingEntry(identifier: .a, routable: self) }
}

// MARK: - Enterable
extension ViewControllerA: Enterable {
    func enterNode(with entry: RoutingEntry, animated: Bool, completion: @escaping ((Bool) -> Void)) {
        switch entry.identifier {
        case .a:
            let vcA = UIStoryboard(name: "ViewControllerA", bundle: nil)
                .instantiateViewController(withIdentifier: "ViewControllerA") as! ViewControllerA
            present(vcA, animated: true) { RoutingTree.default.didEnterNode(withEntry: vcA.entry); completion(true) }

        case .b:
            let vcB = UIStoryboard(name: "ViewControllerB", bundle: nil)
                .instantiateViewController(withIdentifier: "ViewControllerB") as! ViewControllerB
            present(vcB, animated: true) { RoutingTree.default.didEnterNode(withEntry: vcB.entry); completion(true) }

        case .c:
            let vcC = UIStoryboard(name: "ViewControllerC", bundle: nil)
                .instantiateViewController(withIdentifier: "ViewControllerC") as! ViewControllerC
            present(vcC, animated: true) { RoutingTree.default.didEnterNode(withEntry: vcC.entry); completion(true) }

        case .d:
            let vcD = UIStoryboard(name: "ViewControllerD", bundle: nil)
                .instantiateViewController(withIdentifier: "ViewControllerD") as! ViewControllerD
            present(vcD, animated: true) { RoutingTree.default.didEnterNode(withEntry: vcD.entry); completion(true) }

        default:
            completion(false)
        }
    }
}

// MARK: - Leavable
extension ViewControllerA: Leavable {
    func canLeaveNode(with entry: RoutingEntry) -> Bool {
        return entry == self.entry
    }

    func leaveNode(with entry: RoutingEntry, animated: Bool, completion: @escaping (Bool) -> Void) {
        guard entry == self.entry else { return completion(false) }

        dismiss(animated: true) { RoutingTree.default.didLeaveNode(with: self.entry); completion(true) }
    }
}
