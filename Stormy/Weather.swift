//
//  Weather.swift
//  Stormy
//
//  Created by Smithers on 04/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation

struct Weather {
    let currently : CurrentWeather
}


extension Weather {
    
    init?(json: [String: AnyObject]){
        guard let currentWeatherJson = json["currently"] as? [String: AnyObject], let currentWeather = CurrentWeather(json: currentWeatherJson) else {
            return nil
        }
        
        self.currently = currentWeather
    }
    
}
