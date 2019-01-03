//
//  CurrentViewController.swift
//  Sky
//
//  Created by kuroky on 2019/1/3.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

protocol CurrentWeatherViewControllerDelegate: class {
    func locationButtonPressed(
        controller: CurrentViewController)
    func settingsButtonPressed(
        controller: CurrentViewController)
}

class CurrentViewController: WeatherViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: CurrentWeatherViewControllerDelegate?
    
    var now: WeatherData? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    var location: Location? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestData()
    }
    
    func updateView() {
        self.activityIndicatorView.stopAnimating()
        
        if let now = now, let location = location {
            self.updateWeatherContainer(with: now, at: location)
        }
        else {
            self.loadingFailedLabel.isHidden = false
            self.loadingFailedLabel.text = "Cannot load fetch weather/location data from the network."
        }
    }
    
    func requestData() {
        WeatherDataManager.shared.weatherDataAt(latitude: 50, longtitude: 100) { (data, error) in
            self.now = data
        }
    }
    
    func updateWeatherContainer(with data: WeatherData, at location: Location) {
        self.weatherContainerView.isHidden = false
        
        self.locationLabel.text = location.name
        self.temperatureLabel.text = String(format: "%.1f °C", data.currently.temperature.toCelcius())
        
        weatherIcon.image = self.weatherIcon(of: data.currently.icon)
        
        self.humidityLabel.text = String(format: "%.1f %%", data.currently.humidity * 100)
        
        self.summaryLabel.text = data.currently.summary
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        self.dateLabel.text = formatter.string(from: data.currently.time)
    }
    
    //MARK:- Button Action
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        self.delegate?.locationButtonPressed(controller: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        self.delegate?.settingsButtonPressed(controller: self)
    }
}
