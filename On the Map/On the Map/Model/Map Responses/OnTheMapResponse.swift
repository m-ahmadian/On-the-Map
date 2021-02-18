//
//  OnTheMapResponse.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-03.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation

struct OnTheMapResponse: Codable {
    let status: Int
    let error: String
}

extension OnTheMapResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
