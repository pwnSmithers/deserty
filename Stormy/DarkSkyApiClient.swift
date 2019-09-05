//
//  DarkSkyApiClient.swift
//  Stormy
//
//  Created by Smithers on 03/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation


class DarkSkyApiClient {
    
    fileprivate let privateKey = "a68b537824d2345180201e3902397d6a"
    
    lazy var baseUrl: URL = {
        return URL(string: "https://api.darksky.net/forecast/\(privateKey)/")!
    }()
    let session : URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    let downloader = JsonDownloader()
    let decoder = JSONDecoder()
    
    typealias weatherCompletionHandler = (Weather?, Error?) -> Void
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, Error?) -> Void
    
    private func getWeather(at coordinate: Cordinate, completionHandler: @escaping weatherCompletionHandler){
        
        guard let url = URL(string: coordinate.description, relativeTo: baseUrl) else{
            completionHandler(nil, DarkSkyError.invalidURL)
            return
        }
        
        let request = URLRequest(url: url)
        
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completionHandler(nil, DarkSkyError.requestFailed)
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        do{
                            let weather = try self.decoder.decode(Weather.self, from: data)
                            completionHandler(weather, nil)
                        }catch let error {
                            completionHandler(nil, error)
                        }
                    }else{
                        completionHandler(nil, DarkSkyError.invalidData)
                    }
                    
                } else if let error = error {
                    completionHandler(nil, error)
                }
            }
        }
        
        
        task.resume()
    }
    
    func getCurrentWeather(at coordinate: Cordinate, completionHandler completion: @escaping CurrentWeatherCompletionHandler){
        getWeather(at: coordinate) { weather, error in
            
            completion(weather?.currently, error)
        }
    }
    
}

