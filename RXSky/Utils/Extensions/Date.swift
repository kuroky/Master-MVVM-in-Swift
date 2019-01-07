//
//  Date.swift
//  Sky
//
//  Created by kuroky on 2019/1/7.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation

extension Date {
    static func from(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT+8:00")
        return dateFormatter.date(from: string)!
    }
}
