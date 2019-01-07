//
//  Location.swift
//  Sky
//
//  Created by kuroky on 2019/1/2.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Equatable {
    private struct Keys {
        static let name = "name"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    static let empty = Location.init(name: "", latitude: 0, longitude: 0)
    static let invalid = Location.init(name: "n/a", latitude: 0, longitude: 0)
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(from dictionary: [String: Any]) {
        guard let name = dictionary[Keys.name]
            as? String else { return nil }
        guard let latitude = dictionary[Keys.latitude]
            as? Double else { return nil }
        guard let longitude = dictionary[Keys.longitude]
            as? Double else { return nil }
        
        self.init(name: name, latitude: latitude, longitude: longitude)
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var toDictionary: [String: Any] {
        return [
            "name": name,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
    
    var name: String
    var latitude: Double
    var longitude: Double
}
