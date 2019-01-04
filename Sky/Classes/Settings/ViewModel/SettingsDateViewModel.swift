//
//  SettingsDateViewModel.swift
//  Sky
//
//  Created by kuroky on 2019/1/4.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

struct SettingsDateViewModel: SettingsRepresentable {
    let dateMode: DateMode
    
    var labelText: String {
        return dateMode == .text ? "Fri, 01 December" : "F, 12/01"
    }
    
    var accessory: UITableViewCell.AccessoryType {
        if UserDefaults.dateMode() == dateMode {
            return .checkmark
        }
        else {
            return .none
        }
    }
}


