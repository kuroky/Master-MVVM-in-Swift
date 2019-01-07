//
//  CurrentWeatherViewModel.swift
//  Sky
//
//  Created by kuroky on 2019/1/3.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

struct CurrentWeatherViewModel {
    
    static let empty = CurrentWeatherViewModel(weather: WeatherData.empty)
    
    var isEmpty: Bool {
        return self.weather == WeatherData.empty
    }
    
    var weather: WeatherData!
        
    var temperature: String {
        let value = weather.currently.temperature
        
        switch UserDefaults.temperatureMode() {
        case .celsius:
            return String(format: "%.1f °C", value.toCelsius())
        case .fahrenheit:
            return String(format: "%.1f °F", value)
        }
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
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = UserDefaults.dateMode().format
        return formatter.string(from: self.weather.currently.time)
    }
}
