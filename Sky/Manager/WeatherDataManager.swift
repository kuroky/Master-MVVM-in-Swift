//
//  WeatherDataManager.swift
//  Sky
//
//  Created by kuroky on 2019/1/2.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation

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
    
    static let shared = WeatherDataManager(baseURL: API.authenticatedUrl, urlSession: URLSession.shared)
    
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
