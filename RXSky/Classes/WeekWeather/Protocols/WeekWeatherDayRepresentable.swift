//
//  WeekWeatherDayRepresentable.swift
//  Sky
//
//  Created by kuroky on 2019/1/4.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

protocol WeekWeatherDayRepresentable {
    var week: String { get }
    var date: String { get }
    var temperature: String { get }
    var weatherIcon: UIImage? { get }
    var humidity: String { get }
}
