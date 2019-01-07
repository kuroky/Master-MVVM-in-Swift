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
    @IBOutlet weak var retryButton: UIButton!
    
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
        self.setupUI()
        self.setupData()
    }
    
    func setupData() {
        let combined = Observable.combineLatest(locationVM, weatherVM) {
                return ($0, $1)
            }
            .share(replay: 1, scope: .whileConnected)
        
        let viewModel = combined.filter{
            let (location, weather) = $0
            return self.shouldDisplayWeatherContainer(locationVM: location, weatherVM: weather)
        }.asDriver(onErrorJustReturn: (CurrentLocationViewModel.empty, CurrentWeatherViewModel.empty))
        
        viewModel.map { $0.0.city }.drive(self.locationLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.temperature }.drive(self.temperatureLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.weatherIcon }.drive(self.weatherIcon.rx.image).disposed(by: bag)
        viewModel.map { $0.1.humidity }.drive(self.humidityLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.summary }.drive(self.summaryLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.date }.drive(self.dateLabel.rx.text).disposed(by: bag)
        
        combined.map { self.shouldHideWeatherContainer(locationVM: $0.0, weatherVM: $0.1) }
            .asDriver(onErrorJustReturn: true)
            .drive(self.weatherContainerView.rx.isHidden)
            .disposed(by: bag) // view容器
        
        combined.map { self.shouldHideActivityIndicator(locationVM: $0.0, weatherVM: $0.1) }
            .asDriver(onErrorJustReturn: false)
            .drive(self.activityIndicatorView.rx.isHidden)
            .disposed(by: bag)
        
        combined.map { self.shouldAnimateActivityIndicator(locationVM: $0.0, weatherVM: $0.1) }
            .asDriver(onErrorJustReturn: true)
            .drive(self.activityIndicatorView.rx.isHidden)
            .disposed(by: bag)
        
        let errorCond = viewModel.map {
            self.shouldDisplayErrorPrompt(locationVM: $0.0, weatherVM: $0.1)
            }.asDriver(onErrorJustReturn: true)
        
        errorCond.map { !$0 }
            .drive(self.retryButton.rx.isHidden)
            .disposed(by: bag)
        errorCond.map { !$0 }
            .drive(self.loadingFailedLabel.rx.isHidden)
            .disposed(by: bag)
        errorCond.map { _ in return String.ok }
            .drive(self.loadingFailedLabel.rx.text)
            .disposed(by: bag)
    }
    
    override func setupUI() {
        self.retryButton.rx.tap.subscribe(onNext: { _ in
            self.weatherVM.accept(.empty)
            self.locationVM.accept(.empty)
            
            (self.parent as? RootViewController)?.fetchCity()
            (self.parent as? RootViewController)?.fetchWeather()
        }).disposed(by: bag)
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

fileprivate extension CurrentViewController {
    
    func shouldDisplayWeatherContainer(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> Bool {
        return !locationVM.isEmpty && !weatherVM.isEmpty && !locationVM.isInvalid && !weatherVM.isInvalid
    }
    
    func shouldHideWeatherContainer(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> Bool {
        return locationVM.isEmpty || locationVM.isInvalid || weatherVM.isEmpty || weatherVM.isInvalid
    }
    
    func shouldHideActivityIndicator(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> Bool {
        return (!locationVM.isEmpty && !weatherVM.isEmpty) || locationVM.isInvalid || weatherVM.isInvalid
    }
    
    func shouldAnimateActivityIndicator(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> Bool {
        return locationVM.isEmpty || weatherVM.isEmpty
    }
    
    func shouldDisplayErrorPrompt(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> Bool {
        return locationVM.isInvalid || weatherVM.isInvalid
    }
}
