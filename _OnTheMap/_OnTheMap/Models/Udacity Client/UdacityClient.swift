//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class UdacityClient {
    
     private struct LoggedInUserInfo {
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
        case getPublicUserData(String)
        
        var toString: String {
            switch self {
            case .postingSession: return Endpoints.base + "/session"
            case .deletingSession: return Endpoints.base + "/session"
            case .onTheMapUserData: return Endpoints.base + "/users/" + LoggedInUserInfo.username
            case .getPublicUserData(let key): return Endpoints.base + "/users/" + "\(key)"
                
            }
        }
        
        var url: URL {
            return URL(string: self.toString)!
        }
    }
    
    
    class func getPublicUserData(key: String, completion: @escaping(PublicUserDataResponse?, Error?)->Void){
        
        var request = URLRequest(url: Endpoints.getPublicUserData(key).url)
        request.httpMethod = "GET"
        
        print("URL = \(request)")
        
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, err)
                }
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            
            
            do {
                let udacityPublicUserDataObject = try JSONDecoder().decode(PublicUserDataResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(udacityPublicUserDataObject, nil)
                }
                return
            } catch {
                print("Received data but can't convert it to UdacityPublicUserData.type \n\(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
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
        return LoggedInUserInfo.accountKey
    }
    

    
    //MARK:- Log In
    class func authenticateSession(name: String, password: String, completion: @escaping (String?, Error?)-> Void)->URLSessionTask{
        
        let url = Endpoints.postingSession.url
        let userCredentials = LoginRequest(udacity: Credentials(username: name, password: password))
        let task = postRequest(url: url, encodable: userCredentials, decoder: LoginSuccessRequest.self, udacityErrorDecoder: LoginFailedResponse.self) {(loginData, udacityErrData, err) in
            
            if let dataObject = loginData {
                UdacityClient.LoggedInUserInfo.username = name
                UdacityClient.LoggedInUserInfo.password = password
                UdacityClient.LoggedInUserInfo.accountKey = dataObject.account.key
                UdacityClient.LoggedInUserInfo.accountRegistered = dataObject.account.registered
                UdacityClient.LoggedInUserInfo.sessionExpiration = dataObject.session.expiration
                UdacityClient.LoggedInUserInfo.sessionId = dataObject.session.id
                completion(nil, nil)
            } else if let udacityErrorObject = udacityErrData {
                completion(udacityErrorObject.error, nil)
            } else {
                completion(nil, err)
            }
        }
        return task
    }
    
    private class func postRequest<WillEncode: Encodable, Decoder: Decodable, UdacityErrorDecoder: Decodable>(url: URL, encodable: WillEncode, decoder : Decoder.Type, udacityErrorDecoder: UdacityErrorDecoder.Type, completion: @escaping (Decoder?, UdacityErrorDecoder?, Error?)-> Void)->URLSessionTask{
        var request = URLRequest(url: Endpoints.postingSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(encodable)
        
        request.timeoutInterval = loginTimeOut
        
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
                return
            }
        }
        task.resume()
        return task
    }
}

