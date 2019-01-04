//
//  Configuration.swift
//  Sky
//
//  Created by kuroky on 2019/1/2.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

struct API {
    static let key = "c49369ac13275713d92b0f9ea73889c0"
    static let baseUrl = "https://api.darksky.net/forecast/"
    static let authenticatedUrl = URL(string: "\(baseUrl)\(key)/")!
}
