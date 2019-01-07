//
//  MockURLSessionDataTask.swift
//  Sky
//
//  Created by kuroky on 2019/1/2.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation
@testable import Sky

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var isResumedCalled = false
    
    func resume() {
        self.isResumedCalled = true
    }
}
