//
//  SettingsTemperatureViewModel.swift
//  Sky
//
//  Created by kuroky on 2019/1/4.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

struct SettingsTemperatureViewModel: SettingsRepresentable {
    let temperatureMode: TemperatureMode
    
    var labelText: String {
        return temperatureMode == .celsius ? "Celsius" : "Fahrenhait"
    }
    
    var accessory: UITableViewCell.AccessoryType {
        if UserDefaults.temperatureMode() == temperatureMode {
            return .checkmark
        }
        else {
            return .none
        }
    }
}
