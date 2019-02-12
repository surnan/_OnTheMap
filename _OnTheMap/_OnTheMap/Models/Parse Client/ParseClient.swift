//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//case studentLocation

import Foundation

class ParseClient {
    
    static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    enum Endpoints{
        static let base = "https://parse.udacity.com/parse/classes"
        case addStudentLocation
        case changeStudentLocation(String)
        
        var toString: String {
            switch self {
            case .addStudentLocation: return Endpoints.base + "/StudentLocation"
            case .changeStudentLocation(let objectID): return Endpoints.base + "/StudentLocation/" + objectID
            }
        }
        
        var url: URL {
            return URL(string: toString)!
        }
    }
    
    @discardableResult class func taskForGetResponse<Decoder: Decodable>(url: URL, decoder: Decoder.Type, completion: @escaping (Decoder?, Error?)-> Void) -> URLSessionTask{
        var request = URLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            do {
                let dataObject = try JSONDecoder().decode(decoder.self, from: data)
                DispatchQueue.main.async {
                    completion(dataObject, nil)
                }
                return
                
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
        }
        task.resume()
        return task
    }
    
    class func getStudents(completion: @escaping ([PostedStudentInfoResponse], Error?)-> Void)-> URLSessionTask{
//        let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=20000000000000")!
        let url = ParseClient.Endpoints.addStudentLocation.url
        let task = taskForGetResponse(url: url, decoder: ParseRequest.self) { (data, err) in
            if err != nil {
                return completion([], err)
            }
            guard let data = data else {return}
            completion(data.results, nil)
            return
        }
        return task
    }
    
    class func postStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (postStudentLocationResponse?, Error?)->Void){
        let _StudentLocationRequest = StudentLocationRequest(uniqueKey: UdacityClient.getAccountKey(),
                                                             firstName: "Lawrence",
                                                             lastName: "Simmons",
                                                             mapString: mapString,
                                                             mediaURL: mediaURL,
                                                             latitude: latitude,
                                                             longitude: longitude)
        
        taskForPostRequest(url: Endpoints.addStudentLocation.url, body: _StudentLocationRequest, decodeType: postStudentLocationResponse.self) { (data, error) in
            if let err = error {
                completion(nil, err)
                return
            }
            
            
            guard let data = data else {
                print("Data returned from taskForPostRequest is nil and returned error was also nil")
                completion(nil, error)
                return
            }
            
            print("data.createdAt = \(data.createdAt)")
            print("data.objectId = \(data.objectId)")
            completion(data, nil)
            return
        }
    }
    
    
    class func taskForPostRequest<Encoding: Encodable, Decoder: Decodable>(url: URL, body: Encoding, decodeType: Decoder.Type, completion: @escaping (Decoder?, Error?)->Void){
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let body =  try JSONEncoder().encode(body)
            request.httpBody =   body
        } catch {
            print("Unable to encode JSON Body for ParseClient.PostStudentLocation with StudentLocationRequest object")
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                let dataObject = try JSONDecoder().decode(decodeType, from: data)
                DispatchQueue.main.async {
                    completion(dataObject, nil)
                }
                return
            } catch {
                print("Unable to convert data into decodable within taskForPostRequest")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            }.resume()
    }
    
    
    class func changingStudentLocation(objectID: String, encodable: PutRequest, completion: @escaping (Bool, Error?)->Void){
        let url = Endpoints.changeStudentLocation(objectID).url
        
        taskForPutStudentLocation(url: url, encodable: encodable) { (success, err) in
            if success {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                return
            } else {
                DispatchQueue.main.async {
                    completion(false, err)
                }
                return
            }
        }
    }
    
    class func taskForPutStudentLocation(url: URL, encodable: PutRequest, completion: @escaping (Bool, Error?)->Void ){
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let body = try JSONEncoder().encode(encodable)
            request.httpBody = body
        } catch {
            print("unable to encode")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                return
            } else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            }.resume()
    }
}


