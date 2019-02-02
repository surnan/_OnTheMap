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
    
    
    
    class func getStudents(completion: @escaping ([StudentInfo], Error?)-> Void){
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
    
    
    class func getAllStudents(completion: @escaping (ParseRequest?, Error?)-> Void){
        let url = ParseClient.Endpoints.studentLocation.url
        taskForGetResponse(url: url, decoder: ParseRequest.self) { (data, err) in
            if err == nil {
                completion(data, nil)
            } else {
                completion(nil, err)
                // print(data)
            }
            return
        }
    }
    
    
    class func getAllStudents2(completion: @escaping (ParseRequest?, Error?)-> Void){
        let url = ParseClient.Endpoints.studentLocation.url
        var request = URLRequest(url: url)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataObject = data else {return}
            //                        print(String(data: dataObject, encoding: .utf8)!)
            do {
                let allStudentsObject = try JSONDecoder().decode(ParseRequest.self, from: dataObject)
                DispatchQueue.main.async {
                    completion(allStudentsObject, nil)
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
    }
    
}


