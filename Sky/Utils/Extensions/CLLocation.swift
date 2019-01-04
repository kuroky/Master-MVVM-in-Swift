//
//  CLLocation.swift
//  Sky
//
//  Created by kuroky on 2019/1/4.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    var toString: String {
        let latitude = String(format: "%.3f", coordinate.latitude)
        let longitude = String(format: "%.3f", coordinate.longitude)
        
        return "\(latitude), \(longitude)"
    }
}
