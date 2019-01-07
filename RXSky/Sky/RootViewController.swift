//
//  RootViewController.swift
//  Sky
//
//  Created by kuroky on 2019/1/3.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {

    var currentWeatherViewController: CurrentViewController!
    var weekWeatherViewController: WeekWeatherViewController!
    var settingViewController: SettingTableViewController!
    var locationViewController: LocationsViewController!
    
    private let segueCurrentWeather = "SegueCurrentWeather"
    private let segueWeekWeather = "SegueWeekWeather"
    private let segueSettings = "SegueSettings"
    private let segueLocations = "SegueLocations"
    
    private lazy var manager: CLLocationManager = {
       let manager = CLLocationManager()
        manager.distanceFilter = 100
        manager.desiredAccuracy = 100
        return manager
    }()
    
    private var currentLocation: CLLocation? {
        didSet {
            self.fetchCity()
            self.fetchWeather()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupActiveNotification()
        self.requestLocation()
    }
    
    private func setupActiveNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    private func fetchCity() {
        guard let currentLocation = self.currentLocation else {
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                dump(error)
            }
            else if let city = placemarks?.first?.locality {
                // noti vc
                self.currentWeatherViewController.viewModel.location = Location(name: city, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)                
            }
        }
    }
    
    private func fetchWeather() {
        guard let currentLocation = self.currentLocation else {
            return
        }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longtitude: lon) { (data, error) in
            if let error = error {
                dump(error)
                return
            }
            
            if let response = data {
                // noti vc
                self.currentWeatherViewController.viewModel.weather = response
                self.weekWeatherViewController.viewModel = WeekWeatherViewModel(weatherData: response.daily.data)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case segueCurrentWeather:
            guard let destination = segue.destination as? CurrentViewController else {
                fatalError("Invalid destionation currentWeather view controller")
            }
            destination.delegate = self
            destination.viewModel = CurrentWeatherViewModel()
            self.currentWeatherViewController = destination
        case segueWeekWeather:
            guard let destination = segue.destination as? WeekWeatherViewController else {
                fatalError("Invalid destionation weekWeather view controller")
            }
            self.weekWeatherViewController = destination
        case segueSettings:
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Invalid destination view controller!")
            }
            
            guard let destination = navigationController.topViewController as? SettingTableViewController else {
                fatalError("Invalid destionation weekWeather view controller")
            }
            destination.delegate = self
            self.settingViewController = destination
        case segueLocations:
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Invalid destionation weekWeather view controller")
            }
            
            guard let destination = navigationController.topViewController as? LocationsViewController else {
                fatalError("Invalid destionation weekWeather view controller")
            }
            destination.delegate = self
            destination.currentLocation = self.currentLocation
            self.locationViewController = destination
        default:
            break
        }
    }
    
    //MARK:- location
    private func requestLocation() {
        self.manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.manager.requestLocation()
        }
        else {
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    //MARK:- Notification
    @objc func applicationDidBecomeActive(notification: Notification) {
        
    }
    
    @IBAction func unwindToRootViewController(
        segue: UIStoryboardSegue) {
        
    }
}

//MARK:- CLLocationManagerDelegate
extension RootViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
            self.manager.delegate = nil
            self.manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
}

extension RootViewController: CurrentWeatherViewControllerDelegate {
    
    func locationButtonPressed(controller: CurrentViewController) {
        performSegue(withIdentifier: segueLocations, sender: nil)
    }
    
    func settingsButtonPressed(controller: CurrentViewController) {
        performSegue(withIdentifier: segueSettings, sender: nil)
    }
}

extension RootViewController: SettingsViewControllerDelegate {
    private func reloadUI() {
        self.currentWeatherViewController.updateView()
        self.weekWeatherViewController.updateView()
    }

    func controllerDidChangeTimeMode(
        controller: SettingTableViewController) {
        reloadUI()
    }
    
    func controllerDidChangeTemperatureMode(
        controller: SettingTableViewController) {
        reloadUI()
    }
}

extension RootViewController: LocationsViewControllerDelegate {
    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation) {
        currentLocation = location
    }
}
