//
//  CurrentWeatherUITests.swift
//  
//
//  Created by kuroky on 2019/1/3.
//

import XCTest

class CurrentWeatherUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_location_button_exists() {
        let locationBtn = app.buttons["LocationBtn"]
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: locationBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(locationBtn.exists)
    }

}
