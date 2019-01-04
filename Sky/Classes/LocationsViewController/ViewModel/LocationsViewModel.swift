//
//  LocationsViewModel.swift
//  Sky
//
//  Created by kuroky on 2019/1/4.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationsViewModel {
    let location: CLLocation?
    let locationText: String?
}

extension LocationsViewModel: LocationRepresentable {
    var labelText: String {
        if let locationText = locationText {
            return locationText
        }
        else if let location = location {
            return location.toString
        }
        
        return "Unknown position"
    }
}
