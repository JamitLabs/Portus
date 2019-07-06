//
//  TabFlowController.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 09.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import Imperio
import UIKit

/// Abstract superclass for every flow controller whose vc is presented as a tab in a tab bar.
class TabFlowController: FlowController {
    // MARK: - Properties
    private var isStarted: Bool = false
    var tabViewController: UIViewController {
        fatalError("Subclasses must override this.")
    }

    // MARK: - Methods
    override func start(from presentingViewController: UIViewController) {
        fatalError("Don't use this on TabBarFlowController. Use startIfNeeded() instead.")
    }

    func startIfNeeded() {
        if !isStarted {
            isStarted = true
            start()
        }
    }

    func start() {
        // Can be implemented by subclasses if needed
    }

    func leave() {
        // Can be implemented by subclasses if needed
    }
}
