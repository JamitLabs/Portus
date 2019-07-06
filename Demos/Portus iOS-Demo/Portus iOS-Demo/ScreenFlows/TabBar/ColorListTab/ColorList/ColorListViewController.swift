//
//  ViewController.swift
//  Portus iOS-Demo
//
//  Created by Cihat Gündüz on 22.10.18.
//  Copyright © 2018 Jamit Labs. All rights reserved.
//

import UIKit

protocol ColorListViewControllerDelegate: AnyObject {
    func viewController(_ viewController: ColorListViewController, didSelect color: UIColor)
}

class ColorListViewController: UIViewController {
    private enum Constants {
        static let colorCellIdentifier: String = "ColorCell"
    }

    // MARK: - Properties
    weak var delegate: ColorListViewControllerDelegate?

    private let colors = DefaultColorDataSource.colors

    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!

    // MARK: - Methods: - Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Colors"
        view.backgroundColor = UIColor(named: "background")
        tableView.backgroundColor = UIColor(named: "background")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

extension ColorListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.colorCellIdentifier, for: indexPath) as! ColorCell
        return cell
    }
}

extension ColorListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ColorCell)?.viewModel = ColorCellModel(color: colors[indexPath.row])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.viewController(self, didSelect: colors[indexPath.row])
    }
}
