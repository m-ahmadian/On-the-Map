//
//  LoginResponse.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-02.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
