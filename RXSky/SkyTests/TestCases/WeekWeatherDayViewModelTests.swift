//
//  WeekWeatherDayViewModelTests.swift
//  SkyTests
//
//  Created by kuroky on 2019/1/4.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import XCTest
@testable import Sky

class WeekWeatherDayViewModelTests: XCTestCase {
    var vm: WeekWeatherDayViewModel!
    
    override func setUp() {
        super.setUp()
        
        let data = loadDataFromBundle(
            ofName: "DarkSky", ext: "json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let weatherData = try! decoder.decode(
            WeatherData.self, from: data)
        
        vm = WeekWeatherDayViewModel(
            weatherData: weatherData.daily.data[0])
    }

    override func tearDown() {
        super.tearDown()
        
        vm = nil
        UserDefaults.standard.removeObject(
            forKey: UserDefaultsKeys.dateMode)
        UserDefaults.standard.removeObject(
            forKey: UserDefaultsKeys.temperatureMode)
    }

    func test_date_display() {
        XCTAssertEqual(vm.date, "October 5")
    }
    
    func test_week_display() {
        XCTAssertEqual(vm.week, "Thursday")
    }
    
    func test_temperature_display_in_celsius() {
        UserDefaults.standard.set(TemperatureMode.celsius.rawValue, forKey: UserDefaultsKeys.temperatureMode)
        XCTAssertEqual(vm.temperature, "19 °C - 28 °C")
    }
    
    func test_temperature_display_in_fahrenheit() {
        UserDefaults.standard.set(
            TemperatureMode.fahrenheit.rawValue,
            forKey: UserDefaultsKeys.temperatureMode)
        XCTAssertEqual(vm.temperature, "66 °F - 82 °F")
    }
    
    func test_humidity() {
        XCTAssertEqual(vm.humidity, "25 %")
    }
    
    func test_weather_icon_display() {
        let iconFromViewModel =
            UIImage.pngData(vm.weatherIcon!)
        let iconFromTestData =
            UIImage.pngData(UIImage(named: "clear-day")!)
        
        XCTAssertEqual(vm.weatherIcon!.size.width, 128.0)
        XCTAssertEqual(vm.weatherIcon!.size.height, 128.0)
        
        //XCTAssertEqual(iconFromViewModel, iconFromTestData)
    }
}
