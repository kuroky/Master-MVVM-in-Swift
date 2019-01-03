//
//  WeatherDataManager.swift
//  Sky
//
//  Created by kuroky on 2019/1/2.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation

class DarkSkyURLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        return DarkSkyURLSessionDataTask(request: request, completion: completionHandler)
    }
}

class DarkSkyURLSessionDataTask: URLSessionDataTaskProtocol {
    private let request: URLRequest
    private let completion: DataTaskHandler
    
    init(request: URLRequest, completion: @escaping DataTaskHandler) {
        self.request = request
        self.completion = completion
    }
    
    func resume() {
        let json = ProcessInfo.processInfo.environment["FakeJSON"]
        
        if let json = json {
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            let data = json.data(using: .utf8)!
            
            completion(data, response, nil)
        }
    }
}

struct Config {
    private static func isUITesting() -> Bool {
        return ProcessInfo.processInfo.arguments.contains("UI-TESTING")
    }
    
    static var urlSession: URLSessionProtocol = {
        if isUITesting() {
            return DarkSkyURLSession()
        }
        else {
            return URLSession.shared
        }
    }()
}

enum DataManagerError: Error {
    case failedRequest
    case invalidResponse
    case unknown
}

final class WeatherDataManager {
    internal let baseURL: URL
    internal let urlSession: URLSessionProtocol
    internal init(baseURL: URL, urlSession: URLSessionProtocol) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    static let shared = WeatherDataManager(baseURL: API.authenticatedUrl, urlSession: Config.urlSession)
    
    typealias CompletionHandler = (WeatherData?, DataManagerError?) -> Void
    
    //MARK:- weather request
    func weatherDataAt(latitude: Double, longtitude: Double, completion: @escaping CompletionHandler) {
        let url = baseURL.appendingPathComponent("\(latitude),\(longtitude)")
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.urlSession.dataTask(with: request, completionHandler: {(data, response, error) in
            self.didFinishGettingWeatherData(data: data, response: response, error: error, completion: completion)
        }).resume()
    }
    
    func didFinishGettingWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: CompletionHandler) {
        if let _ = error {
            completion(nil, DataManagerError.failedRequest) // error
            return
        }
            
        guard let data = data, let response = response as? HTTPURLResponse else {
            completion(nil, DataManagerError.invalidResponse) // parser error
            return
        }
        
        if response.statusCode == 200 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            guard let weatherData = try? decoder.decode(WeatherData.self, from: data) else {
                completion(nil, DataManagerError.invalidResponse) // parser error
                return
            }
            completion(weatherData, nil)
        }
        else {
            completion(nil, DataManagerError.failedRequest) // error
        }
    }
}
