//
//  WeekWeatherViewController.swift
//  Sky
//
//  Created by kuroky on 2019/1/3.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

class WeekWeatherViewController: WeatherViewController {

    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    var viewModel: WeekWeatherViewModel? {
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
        self.updateContainerView()
    }
    
    func updateContainerView() {
        self.activityIndicatorView.stopAnimating()
        
        if let _ = self.viewModel {
            self.weatherContainerView.isHidden = false
            self.weekWeatherTableView.reloadData()
        }
        else {
            self.loadingFailedLabel.isHidden = false
            self.loadingFailedLabel.text = "Cannot load fetch weather/location data from the network."
        }
    }
}

extension WeekWeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let vm = self.viewModel else {
            return 0
        }
        return vm.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm = self.viewModel else {
            return 0
        }
        return vm.numberOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeekWeatherCell.reuseIdentifier, for: indexPath) as! WeekWeatherCell
        if let weatherDay = self.viewModel?.viewModel(for: indexPath.row) {
            cell.configItem(item: weatherDay)
        }
        return cell
    }
}
