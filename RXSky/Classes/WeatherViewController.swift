//
//  WeatherViewController.swift
//  Sky
//
//  Created by kuroky on 2019/1/3.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherContainerView: UIView!
    @IBOutlet weak var loadingFailedLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        self.weatherContainerView.isHidden = true
        self.loadingFailedLabel.isHidden = true
        self.activityIndicatorView.startAnimating()
        self.activityIndicatorView.hidesWhenStopped = true
    }
}
