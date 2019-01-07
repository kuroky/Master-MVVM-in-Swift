//
//  Double.swift
//  Sky
//
//  Created by kuroky on 2019/1/3.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation

extension Double {
    func toCelsius() -> Double {
        return (self - 32.0) / 1.8
    }
}
