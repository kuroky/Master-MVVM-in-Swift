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
    
    var viewModel: CurrentWeatherViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateView() {
        self.activityIndicatorView.stopAnimating()
        if let data = self.viewModel, self.viewModel.isUpdateReady {
            self.updateWeatherContainer(with: data)
        }
        else {
            self.loadingFailedLabel.isHidden = false
            self.loadingFailedLabel.text = "Cannot load fetch weather/location data from the network."
        }
    }
    
    func updateWeatherContainer(with data: CurrentWeatherViewModel) {
        self.weatherContainerView.isHidden = false
        
        self.locationLabel.text = data.city
        self.temperatureLabel.text = data.temperature
        self.weatherIcon.image = data.weatherIcon
        self.humidityLabel.text = data.humidity
        self.summaryLabel.text = data.summary
        self.dateLabel.text =  data.time
    }
    
    //MARK:- Button Action
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        self.delegate?.locationButtonPressed(controller: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        self.delegate?.settingsButtonPressed(controller: self)
    }
}
