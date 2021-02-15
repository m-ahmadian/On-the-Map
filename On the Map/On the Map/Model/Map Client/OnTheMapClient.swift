//
//  OnTheMapClient.swift
//  On the Map
//
//  Created by Mehrdad on 2021-02-02.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation

class OnTheMapClient {
    
    struct Auth {
        static var sessionId = ""
        static var objectId = ""
        static var uniqueKey = ""
        static var firstName = ""
        static var lastName = ""
    }
    
    enum Endpoins {
        static let base = "https://onthemap-api.udacity.com/v1/"
        static let session = "session"
        static let limit = "?limit=100"
//        static let limit = "?limit=200&skip=400"
        
        case createSessionId
        case signUp
        case logout
        case getStudentLocations
        case getUserData
        case postStudentLocation
        
        
        var stringValue: String {
            switch self {
            case .createSessionId:
                return Endpoins.base + Endpoins.session
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            case .logout:
                return Endpoins.base + Endpoins.session
            case .getStudentLocations:
                return Endpoins.base + "StudentLocation" + Endpoins.limit + "&order=-updatedAt"
            case .getUserData:
                return Endpoins.base + "users/" + Auth.objectId
            case .postStudentLocation:
                return Endpoins.base + "StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    
    }
    
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoins.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                Auth.sessionId = responseObject.session.id
                Auth.objectId = responseObject.account.key
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
//                DispatchQueue.main.async {
//                    completion(false, error)
//                }
                
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                }
                
            }
            
        }
        task.resume()
    }
    
    
    
    class func getStudentLocations(completion: @escaping ([Results], Error?) -> Void) {
        let request = URLRequest(url: Endpoins.getStudentLocations.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(LocationsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.results, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    
    
    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: Endpoins.getUserData.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(UserDataResponse.self, from: newData)
                Auth.firstName = responseObject.firstName
                Auth.lastName = responseObject.lastName
                Auth.uniqueKey = responseObject.key
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoins.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(Auth.uniqueKey)\", \"firstName\": \"\(Auth.firstName)\", \"lastName\": \"\(Auth.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            DispatchQueue.main.async {
                completion(true, nil)
            }
        }
        task.resume()
    }
    
    
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoins.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            Auth.objectId = ""
            completion()
        }
        task.resume()
        
    }
    
}


