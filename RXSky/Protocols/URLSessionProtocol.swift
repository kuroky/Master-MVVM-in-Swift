//
//  URLSessionProtocol.swift
//  Sky
//
//  Created by kuroky on 2019/1/2.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation

typealias DataTaskHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol
}
