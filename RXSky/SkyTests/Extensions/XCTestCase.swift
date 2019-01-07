//
//  XCTestCase.swift
//  SkyTests
//
//  Created by kuroky on 2019/1/4.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import XCTest

extension XCTestCase {
    func loadDataFromBundle(
        ofName name: String,
        ext: String) -> Data {
        let principleClass = type(of: self)
        let bundle = Bundle(for: principleClass)
        let url = bundle.url(forResource: name, withExtension: ext)
        
        return try! Data(contentsOf: url!)
    }
}
