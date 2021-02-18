//
//  StudentLocationRequest.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-17.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation

struct StudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
