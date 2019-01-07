//
//  SettingsRepresentable.swift
//  Sky
//
//  Created by kuroky on 2019/1/4.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

protocol SettingsRepresentable {
    var labelText: String { get }
    var accessory: UITableViewCell.AccessoryType { get }
}

