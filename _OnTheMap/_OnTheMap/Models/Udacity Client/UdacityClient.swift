//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class UdacityClient {
    private struct UserInfo {
        static var username = ""
        static var password = ""
        static var accountRegistered = false
        static var accountKey = ""
        static var sessionId = ""
        static var sessionExpiration = ""
    }
    
    private enum Endpoints {
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
    
    
    class func logout(completion: @escaping ()-> Void){
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
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            }.resume()
        print("Logged out")
        completion()
        return
    }
    
    //Used by  class func setupFromAnnotationController(mapString: String, mediaURL: String, location: CLLocation){
    class func getAccountKey()-> String {
        return UserInfo.accountKey
    }
    
    private class func postRequest<WillEncode: Encodable, Decoder: Decodable, UdacityErrorDecoder: Decodable>(url: URL, encodable: WillEncode, decoder : Decoder.Type, udacityErrorDecoder: UdacityErrorDecoder.Type, completion: @escaping (Decoder?, UdacityErrorDecoder?, Error?)-> Void){
        var request = URLRequest(url: Endpoints.postingSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(encodable)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            do {
                let dataObject = try JSONDecoder().decode(decoder.self, from: newData)
                DispatchQueue.main.async {
                    completion(dataObject, nil, nil)
                }
                return
            } catch let decodeErr {
                print("Unable to decode\n\(decodeErr)")
                
                do {
                    let udacityErrorResponseObject = try JSONDecoder().decode(udacityErrorDecoder.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, udacityErrorResponseObject, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, nil, error)
                    }
                }
                
                
                //                DispatchQueue.main.async {
                //                    completion(nil, decodeErr)
                //                }
                return
            }
            }.resume()
    }
    
    
    class func authenticateSession(name: String, password: String, completion: @escaping (String?, Error?)-> Void){
        let url = Endpoints.postingSession.url
        let userCredentials = UdacityRequest(udacity: Credentials(username: name, password: password))
        postRequest(url: url, encodable: userCredentials, decoder: UdacityResponse.self, udacityErrorDecoder: UdacityErrorResponse.self) {(loginData, udacityErrData, err) in
            
            if let dataObject = loginData {
                UserInfo.username = name
                UserInfo.password = password
                UserInfo.accountKey = dataObject.account.key
                UserInfo.accountRegistered = dataObject.account.registered
                UserInfo.sessionExpiration = dataObject.session.expiration
                UserInfo.sessionId = dataObject.session.id
                completion(nil, nil)
                return
            } else if let udacityErrorObject = udacityErrData {
                completion(udacityErrorObject.error, nil)
                return
            } else {
                completion(nil, err)
                return
            }
        }
    }
}


/*
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
 */

