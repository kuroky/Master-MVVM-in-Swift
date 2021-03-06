
//
//  CurrentLocationViewModel.swift
//  Sky
//
//  Created by kuroky on 2019/1/7.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation

struct CurrentLocationViewModel {
    var location: Location
    
    var city: String {
        return location.name
    }
    
    static let empty = CurrentLocationViewModel.init(location: Location.empty)
    
    static let invalid = CurrentLocationViewModel.init(location: Location.invalid)
    
    var isEmpty: Bool {
        return self.location == Location.empty
    }
    
    var isInvalid: Bool {
        return self.location == Location.invalid
    }
}
