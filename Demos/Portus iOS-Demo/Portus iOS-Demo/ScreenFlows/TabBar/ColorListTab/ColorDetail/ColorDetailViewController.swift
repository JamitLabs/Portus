//
//  ColorDetailViewController.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 10.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import UIKit

protocol ColorDetailViewControllerDelegate: AnyObject {
    func actionButtonTriggered()
    func viewDidDisappear(in viewController: ColorDetailViewController)
}

class ColorDetailViewController: UIViewController {
    weak var delegate: ColorDetailViewControllerDelegate?

    @IBOutlet private var titleLabel: UILabel!

    var viewModel: ColorDetailViewModel? {
        didSet {
            view.backgroundColor = viewModel?.color
            titleLabel.text = viewModel?.color?.hexString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(actionButtonTriggered))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            delegate?.viewDidDisappear(in: self)
        }
    }

    @objc
    private func actionButtonTriggered() {
        delegate?.actionButtonTriggered()
    }
}
