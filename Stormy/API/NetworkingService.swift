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
    case ReverseGeocoding(lat: Double, lng: Double)
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
        case .ReverseGeocoding(let lat, let lng):
            let url =  "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&location_type=ROOFTOP&result_type=street_address&key=\(GlobalConstants.googleGeoCodingApiKey)"
            let finalURL = url.replacingOccurrences(of: " ", with: "+")
            return URL(string: finalURL)!
        }
    }
    
    var path: String {
        switch self {
        case .Geocoding:
            return ""
        case .CurrentWeather(let coordinate):
            return coordinate.description
        case .ReverseGeocoding:
            return ""
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
        case .ReverseGeocoding(let lat, let lng):
            return "{'lat':'\(lat),'lng':'\(lng)''}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["content-type":"application/json"]
    }
    

    
}
