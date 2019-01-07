//
//  CurrentViewController.swift
//  Sky
//
//  Created by kuroky on 2019/1/3.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    private var bag = DisposeBag()
    var weatherVM: BehaviorRelay<CurrentWeatherViewModel> = BehaviorRelay(value: CurrentWeatherViewModel.empty)
    var locationVM: BehaviorRelay<CurrentLocationViewModel> = BehaviorRelay(value: CurrentLocationViewModel.empty)
    
//    var viewModel: CurrentWeatherViewModel! {
//        didSet {
//            DispatchQueue.main.async {
//                self.updateView()
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = Observable.combineLatest(locationVM, weatherVM) {
                return ($0, $1)
            }
            .filter {
                let (location, weather) = $0
                return !(location.isEmoty) && !(weather.isEmpty)
            }
            .share(replay: 1, scope: .whileConnected)
            .observeOn(MainScheduler.instance)
        
        viewModel.map {_ in false }.bind(to: self.activityIndicatorView.rx.isAnimating).disposed(by: bag)
        viewModel.map {_ in false }.bind(to: self.weatherContainerView.rx.isHidden).disposed(by: bag)
        
        viewModel.map {$0.0.city }.bind(to: self.locationLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.temperature }.bind(to: self.temperatureLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.weatherIcon }.bind(to: self.weatherIcon.rx.image).disposed(by: bag)
        viewModel.map { $0.1.humidity }.bind(to: self.humidityLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.summary }.bind(to: self.summaryLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.date }.bind(to: self.dateLabel.rx.text).disposed(by: bag)
    }
    
    func updateView() {
        self.activityIndicatorView.stopAnimating()
        self.weatherVM.accept(weatherVM.value)
        self.locationVM.accept(locationVM.value)
    }
    
    
    //MARK:- Button Action
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        self.delegate?.locationButtonPressed(controller: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        self.delegate?.settingsButtonPressed(controller: self)
    }
}
