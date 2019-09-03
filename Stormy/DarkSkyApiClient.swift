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
    
    let downloader = JsonDownloader()
    
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void
    
    func getCurrentWeather(at coordinate: Cordinate, completionHandler: @escaping CurrentWeatherCompletionHandler){
        
        guard let url = URL(string: coordinate.description, relativeTo: baseUrl) else{
            completionHandler(nil, .invalidURL)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error  in
            
            print(json)
            
        }
        
    }
    
}
