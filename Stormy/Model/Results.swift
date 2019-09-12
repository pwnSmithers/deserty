//
//  Results.swift
//  Stormy
//
//  Created by Smithers on 06/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation


struct Results : Codable {
    let results : [Geometry]
}

struct Geometry: Codable {
    let formatted_address : String
    let geometry : Location
}

struct Location: Codable {
    let location : cordinates
}

struct cordinates: Codable {
    let lat: Double
    let lng: Double
}
