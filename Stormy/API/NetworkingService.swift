//
//  NetworkingService.swift
//  Stormy
//
//  Created by Smithers on 10/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation
import Moya

enum NetworkingService {
    case Geocoding(place: String)
    case CurrentWeather(coordinate: Cordinate)
}

extension NetworkingService : TargetType {
    var baseURL: URL {
        switch self {
        case .Geocoding(let place):
            let url =  "https://maps.googleapis.com/maps/api/geocode/json?address=\(place)&key=\(GlobalConstants.googleGeoCodingApiKey)"
            let finalURL = url.replacingOccurrences(of: " ", with: "+")
            return URL(string: finalURL)!
        case .CurrentWeather:
              return URL(string: "https://api.darksky.net/forecast/\(GlobalConstants.privateKey)/")!
        }
    }
    
    var path: String {
        switch self {
        case .Geocoding:
            return ""
        case .CurrentWeather(let coordinate):
            return coordinate.description
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .Geocoding(let place):
            return "{'place':'\(place)'}".data(using: .utf8)!
        case .CurrentWeather(let coordinate):
            return "{'coordinate':'\(coordinate)'}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["content-type":"application/json"]
    }
    

    
}

class CompleteUrlLoggerPlugin : PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        print(request.request?.url?.absoluteString ?? "Something is wrong")
    }
}
