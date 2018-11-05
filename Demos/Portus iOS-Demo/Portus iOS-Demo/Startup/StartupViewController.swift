//
//  ViewController.swift
//  Portus iOS-Demo
//
//  Created by Cihat Gündüz on 22.10.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import Portus
import UIKit

class StartupViewController: UIViewController {
    // MARK: - Properties
    weak var flowDelegate: StartupFlowDelegate?

    // MARK: - Outlets
    @IBOutlet private var flowAButton: UIButton!
    @IBOutlet private var flowBButton: UIButton!

    // MARK: - Methods: - Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    @IBAction private func flowAButtonTapped(sender: AnyObject) {
        flowDelegate?.flowAButtonTapped()
    }

    @IBAction private func flowBButtonTapped(sender: AnyObject) {
        flowDelegate?.flowBButtonTapped()
    }
}
