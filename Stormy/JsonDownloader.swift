//
//  JsonDownloader.swift
//  Stormy
//
//  Created by Smithers on 02/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation

class JsonDownloader {
    
    let session : URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias JSON = [String: AnyObject]
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping (JSON?, DarkSkyError)-> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
        }
        return task
    }
    
}
