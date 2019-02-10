//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class UdacityClient {
    struct UserInfo {
        static var username = ""
        static var password = ""
        static var accountRegistered = false
        static var accountKey = ""
        static var sessionId = ""
        static var sessionExpiration = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        case postingSession
        case deletingSession
        case onTheMapUserData
        
        var toString: String {
            switch self {
            case .postingSession: return Endpoints.base + "/session"
            case .deletingSession: return Endpoints.base + "/session"
            case .onTheMapUserData: return Endpoints.base + "/users/" + UserInfo.username
            }
        }
        
        var url: URL {
            return URL(string: self.toString)!
        }
    }
    
    
    class func logout(){
        var request = URLRequest(url: Endpoints.deletingSession.url)
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
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        print("Logged out")
        
    }
    
    class func getAccountKey()-> String {
        return UserInfo.accountKey
    }
    
    class func postRequest<WillEncode: Encodable, Decoder: Decodable>(url: URL, encodable: WillEncode, decoder : Decoder.Type,
                                                                      completion: @escaping (Decoder?, Error?)-> Void){
        var request = URLRequest(url: Endpoints.postingSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(encodable)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            
            do {
                let dataObject = try JSONDecoder().decode(decoder.self, from: newData)
                DispatchQueue.main.async {
                    completion(dataObject, nil)
                }
                return
            } catch let decodeErr {
                print("Unable to decode\n\(decodeErr)")
                DispatchQueue.main.async {
                    completion(nil, decodeErr)
                }
                return
            }
            }.resume()
    }
    
    
    class func authenticateSession(name: String, password: String, completion: @escaping (Error?)-> Void){
        let url = Endpoints.postingSession.url
        let userCredentials = UdacityRequest(udacity: Credentials(username: name, password: password))
        postRequest(url: url, encodable: userCredentials, decoder: UdacityResponse.self) {(data, err) in
            if err != nil {
                completion(err)
                return
            }
            guard let dataObject = data else {return}
            UserInfo.username = name
            UserInfo.password = password
            UserInfo.accountRegistered = dataObject.account.registered
            UserInfo.accountKey = dataObject.account.key
            UserInfo.sessionId = dataObject.session.id
            UserInfo.sessionExpiration = dataObject.session.expiration
            completion(nil)
            return
        }
    }
}

