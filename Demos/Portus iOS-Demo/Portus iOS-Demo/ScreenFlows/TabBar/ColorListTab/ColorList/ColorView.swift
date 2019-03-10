//
//  File.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 10.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import UIKit

@IBDesignable
class ColorView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
    }
}
