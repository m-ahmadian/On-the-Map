//
//  UserDataResponse.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-07.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation

struct UserDataResponse: Codable {
    let lastName: String
    let firstName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case key
    }
}


