//
//  Cordinate.swift
//  Stormy
//
//  Created by Smithers on 03/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation


struct Cordinate {
    let latitude : Double
    let longitude : Double
}

extension Cordinate: CustomStringConvertible {
    var description: String {
        return "\(latitude), \(longitude)"
    }
    
    static var alcatrazIsland: Cordinate {
        return Cordinate(latitude: 37.8267, longitude: -122.4233)
    }
}
