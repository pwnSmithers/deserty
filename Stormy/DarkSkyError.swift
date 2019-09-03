//
//  DarkSkyError.swift
//  Stormy
//
//  Created by Smithers on 02/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation


enum DarkSkyError: Error {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidURL
}
