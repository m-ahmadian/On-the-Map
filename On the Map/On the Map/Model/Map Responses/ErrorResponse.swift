//
//  ErrorResponse.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-15.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let status: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "error"
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
