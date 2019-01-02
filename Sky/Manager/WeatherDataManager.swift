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
    private let baseURL: URL
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    static let shared = WeatherDataManager(baseURL: API.authenticatedUrl)
    
    typealias CompletionHandler = (WeatherData?, DataManagerError?) -> Void
    
    func weatherDataAt (latitude: Double, longtitude: Double, completion: @escaping CompletionHandler) {
        let url = baseURL.appendingPathComponent("\(latitude),\(longtitude)")
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            DispatchQueue.main.async {
                self.didFinishGettingWeatherData(data: data, response: response, error: error, completion: completion)
            }
        }).resume()
    }
    
    func didFinishGettingWeatherData (data: Data?, response: URLResponse?, error: Error?, completion: CompletionHandler) {
        if let _ = error {
            completion(nil, DataManagerError.failedRequest)
        }
            
        guard let data = data, let response = response as? HTTPURLResponse else {
            completion(nil, DataManagerError.invalidResponse)
            return
        }
        
        if response.statusCode == 200 {
            guard let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                completion(nil, DataManagerError.invalidResponse)
                return
            }
            completion(weatherData, nil)
        }
        else {
            completion(nil, DataManagerError.failedRequest)
        }
    }
}
