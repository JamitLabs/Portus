//
//  ColorCell.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 10.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import UIKit

class ColorCell: UITableViewCell {
    @IBOutlet private var colorView: ColorView!
    @IBOutlet private var titleLabel: UILabel!

    var viewModel: ColorCellModel? {
        didSet {
            colorView.backgroundColor = viewModel?.color
            titleLabel.text = viewModel?.hexString
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
}
