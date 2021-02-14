//
//  LocationsResponse.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-03.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation

struct LocationsResponse: Codable {
    let results: [Results]
}

struct Results: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
