//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class ParseClient {
    
    static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    enum Endpoints{
        static let base = "https://parse.udacity.com/parse/classes"
        case studentLocation
        
        var toString: String {
            switch self {
            case .studentLocation: return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: toString)!
        }
    }
    
    class func taskForGetResponse<Decoder: Decodable>(url: URL, decoder: Decoder.Type, completion: @escaping (Decoder?, Error?)-> Void){
        var request = URLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
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
            }.resume()
    }
    
    
    
    class func getStudents(completion: @escaping ([PostedStudentInfoResponse], Error?)-> Void){
        let url = ParseClient.Endpoints.studentLocation.url
        taskForGetResponse(url: url, decoder: ParseRequest.self) { (data, err) in
            if err != nil {
                return completion([], err)
            }
            guard let data = data else {return}
            completion(data.results, nil)
            return
        }
    }

    
//    class func postStudentLocation<Encode: Encodable, Decoder: Decodable> (url: URL, encoding: Encode, decoder: Decoder.Type){
    class func postStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double){

        let _StudentLocationRequest = StudentLocationRequest(uniqueKey: UdacityClient.getAccountKey(),
                                          firstName: "John",
                                          lastName: "Snow",
                                          mapString: mapString,
                                          mediaURL: mediaURL,
                                          latitude: latitude,
                                          longitude: longitude)
        
        taskForPostRequest(url: Endpoints.studentLocation.url, body: _StudentLocationRequest, decodeType: postStudentLocationResponse.self) { (data, error) in
            if error != nil {
                print("Object found")
            }
            
            guard let data = data else {
                print("Data returned from taskForPostRequest is nil and returned error was also nil")
                return
            }
            
            print("data.createdAt = \(data.createdAt)")
            print("data.objectId = \(data.objectId)")
            
        }
        
    }
    
    
    class func taskForPostRequest<Encoding: Encodable, Decoder: Decodable>(url: URL, body: Encoding, decodeType: Decoder.Type, completion: @escaping (Decoder?, Error?)->Void){
        
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        
        do {
            let body =  try JSONEncoder().encode(body)
            request.httpBody =   body
            print(body)
        } catch {
            print("Unable to encode JSON Body for ParseClient.PostStudentLocation with StudentLocationRequest object")
            return
        }
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let dataObject = try JSONDecoder().decode(decodeType, from: data)
                completion(dataObject, nil)
                return
                
            }catch {
                print("Unable to convert data into decodable within taskForPostRequest")
                completion(nil, error)
                return
            }
            
            
            
            
            
            }.resume()
        
        
    }
    
    
    
    
    
    
}


