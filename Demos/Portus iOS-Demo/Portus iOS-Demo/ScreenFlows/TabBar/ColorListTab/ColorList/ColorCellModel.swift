//
//  ColorViewModel.swift
//  Portus iOS-Demo
//
//  Created by Andreas Link on 10.03.19.
//  Copyright © 2019 Jamit Labs. All rights reserved.
//

import UIKit

struct ColorCellModel {
    var color: UIColor
    var hexString: String { return color.hexString }
}
