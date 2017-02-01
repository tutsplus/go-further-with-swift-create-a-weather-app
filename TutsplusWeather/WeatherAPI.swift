//
//  WeatherAPI.swift
//  TutsplusWeather
//
//  Created by Markus Mühlberger on 01/02/2017.
//  Copyright © 2017 Markus Mühlberger. All rights reserved.
//

import Foundation

let apiKey = "1feb05aef13518a2d1b8be108ce0a2b3"
let weatherURL = "http://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&APPID={apiKey}&units=metric"

class WeatherAPI {
    public static let shared = WeatherAPI()
    
    let session : URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.allowsCellularAccess = false
        
        session = URLSession(configuration: configuration)
        
    }
    
    public func getWeatherData(latitude: Double, longitude: Double, completion: @escaping (Any?, Error?) -> ()) {
        var request = URLRequest(url: apiUrl(latitude: latitude, longitude: longitude))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            if let response = (response as? HTTPURLResponse) {
                print("Status Code: \(response.statusCode)")
//                print("Headers: \(response.allHeaderFields)")
                
                let json = try? JSONSerialization.jsonObject(with: data)
                
                OperationQueue.main.addOperation {
                    self.networkIndicatorCount -= 1
                    completion(json, nil)
                }
            } else {
                OperationQueue.main.addOperation {
                    self.networkIndicatorCount -= 1
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    private func apiUrl(latitude: Double, longitude: Double) -> URL {
        let url = weatherURL.replacingOccurrences(of: "{apiKey}", with: apiKey)
            .replacingOccurrences(of: "{lat}", with: String(latitude))
            .replacingOccurrences(of: "{lon}", with: String(longitude))
        
        return URL(string: url)!
    }
}
