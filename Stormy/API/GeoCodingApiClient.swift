//
//  GeoCodingApiClient.swift
//  Stormy
//
//  Created by Smithers on 06/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation


class GeoCodingApiClient {
    
    lazy var geoCodeUrl: URL = {
        return URL(string: "https://maps.googleapis.com/maps/api/geocode/json?")!
    }()
    let locationDummyHolder = "Najjera"
    let session : URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    let decoder = JSONDecoder()
    
    typealias weatherCompletionHandler = (Weather?, Error?) -> Void
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, Error?) -> Void
    
    typealias cordinatesCompletionHandler = (Results?, Error?) -> Void
    
    private func getCordinates(at place: Place, completionHandler: @escaping cordinatesCompletionHandler){
        
        guard let url = URL(string: locationDummyHolder, relativeTo: geoCodeUrl) else{
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
                            let results = try self.decoder.decode(Results.self, from: data)
                            completionHandler(results, nil)
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
}
