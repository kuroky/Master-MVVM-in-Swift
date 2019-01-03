//
//  CurrentWeatherViewModel.swift
//  Sky
//
//  Created by kuroky on 2019/1/3.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

struct CurrentWeatherViewModel {
    
    var isLocationReady = false
    var isWeatherReady = false
    
    var weather: WeatherData! {
        didSet {
            if weather != nil {
                self.isWeatherReady = true
            }
            else {
                self.isWeatherReady = false
            }
        }
    }
    
    var location: Location! {
        didSet {
            if location != nil {
                self.isLocationReady = true
            }
            else {
                self.isLocationReady = false
            }
        }
    }
    
    var isUpdateReady: Bool {
        return isLocationReady && isWeatherReady
    }
    
    var city: String {
        return self.location.name
    }
    
    var temperature: String {
        return String(format: "%.1f °C", weather.currently.temperature.toCelsius())
    }
    
    var weatherIcon: UIImage? {
        return UIImage.weatherIcon(of: weather.currently.icon)
    }
    
    var humidity: String {
        return String(format: "%.1f %%", weather.currently.humidity * 100)
    }
    
    var summary: String {
        return self.weather.currently.summary
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        return formatter.string(from: self.weather.currently.time)
    }
}
