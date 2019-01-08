//
//  RootViewController.swift
//  Sky
//
//  Created by kuroky on 2019/1/3.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class RootViewController: UIViewController {

    var currentWeatherViewController: CurrentViewController!
    var weekWeatherViewController: WeekWeatherViewController!
    var settingViewController: SettingTableViewController!
    var locationViewController: LocationsViewController!
    
    private let segueCurrentWeather = "SegueCurrentWeather"
    private let segueWeekWeather = "SegueWeekWeather"
    private let segueSettings = "SegueSettings"
    private let segueLocations = "SegueLocations"
    
    private var bag = DisposeBag()
    
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
    
    func fetchCity() {
        guard let currentLocation = self.currentLocation else {
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                dump(error)
                self.currentWeatherViewController.locationVM.accept(CurrentLocationViewModel.invalid)
            }
            else if let city = placemarks?.first?.locality {
                // noti vc
                let location = Location(name: city, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                self.currentWeatherViewController.locationVM.accept(CurrentLocationViewModel(location: location))
            }
        }
    }
    
    func fetchWeather() {
        guard let currentLocation = self.currentLocation else {
            return
        }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        let weather = WeatherDataManager.shared.weatherDataAt(latitude: lat, longtitude: lon).share(replay: 1, scope: .whileConnected)
        weather.map { CurrentWeatherViewModel(weather: $0) }.bind(to: self.currentWeatherViewController.weatherVM).disposed(by: bag)
        weather.subscribe(onNext: {
            self.weekWeatherViewController.viewModel = WeekWeatherViewModel(weatherData: $0.daily.data)
        }).disposed(by: bag)
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
            //destination.viewModel = CurrentWeatherViewModel()
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
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.manager.startUpdatingLocation()
            self.manager.rx.didUpdateLocations.take(1).subscribe(onNext: {
                    self.currentLocation = $0.first
                }).disposed(by: bag)
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
        self.currentWeatherViewController.weatherVM.accept(CurrentWeatherViewModel.empty)
        self.currentWeatherViewController.locationVM.accept(CurrentLocationViewModel.empty)
        currentLocation = location
    }
}
