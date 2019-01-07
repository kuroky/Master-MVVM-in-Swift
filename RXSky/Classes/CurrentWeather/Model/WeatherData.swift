//
//  WeatherData.swift
//  Sky
//
//  Created by kuroky on 2019/1/2.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let currently: CurrentWeather
    let daily: WeekWeatherData
    
    struct CurrentWeather: Codable {
        let time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
    
    struct WeekWeatherData: Codable {
        let data: [ForecastData]
    }
    
    static let empty = WeatherData.init(latitude: 0, longitude: 0, currently: CurrentWeather.init(time: Date(), summary: "", icon: "", temperature: 0, humidity: 0), daily: WeekWeatherData.init(data: []))
}

extension WeatherData: Equatable {
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.currently == rhs.currently &&
            lhs.daily == rhs.daily
    }
}

extension WeatherData.CurrentWeather: Equatable {
    static func == (lhs: WeatherData.CurrentWeather, rhs: WeatherData.CurrentWeather) -> Bool {
        return lhs.time == rhs.time &&
            lhs.summary == rhs.summary &&
            lhs.icon == rhs.icon &&
            lhs.temperature == rhs.temperature &&
            lhs.humidity == rhs.humidity
    }
}

extension WeatherData.WeekWeatherData: Equatable {
    static func == (lhs: WeatherData.WeekWeatherData, rhs: WeatherData.WeekWeatherData) -> Bool {
        return lhs.data == rhs.data
    }
}

