//
//  ViewController.swift
//  Sky
//
//  Created by kuroky on 2018/12/29.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherDataManager.shared.weatherDataAt(latitude: 52, longtitude: 100) { (response, error) in
            print(response)
            //data = response
            //expect.fulfill()
        }
    }
    
    
    
}

