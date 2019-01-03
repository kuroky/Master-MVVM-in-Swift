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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension WeekWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
