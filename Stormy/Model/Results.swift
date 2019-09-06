//
//  Results.swift
//  Stormy
//
//  Created by Smithers on 06/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation


struct Results : Codable {
    let result : Geometry
}

struct Geometry: Codable {
    let location : Location
}

struct Location: Codable {
    let lat : Double
    let lng : Double
}
