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
    typealias JsonTaskCompletionHandler = (JSON?, DarkSkyError?)-> Void
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JsonTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
                        completion(json, nil)
                    }catch{
                        completion(nil, .jsonParsingFailure)
                    }
                    
                }else{
                    completion(nil, .invalidData)
                }
                
                
            }else{
                completion(nil, .responseUnsuccessful(statusCode: httpResponse.statusCode))
            }
            
        }
        return task
    }
    
}
