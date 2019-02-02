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
    
    class func taskForGetResponse<ResponseType: Decodable>(request: URLRequest, responseObject: ResponseType.Type, completion: @escaping (ResponseType?, Error?)-> Void){
    }
    
    
    
    
    class func getAllStudents(completion: @escaping (ParseRequest?, Error?)-> Void){
        let url = ParseClient.Endpoints.studentLocation.url
        var request = URLRequest(url: url)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataObject = data else {return}
//                        print(String(data: dataObject, encoding: .utf8)!)
//                        print("temp")
            do {
                let allStudentsObject = try JSONDecoder().decode(ParseRequest.self, from: dataObject)
//                print(allStudentsObject)
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


/*
 class func getAllStudents(completion: @escaping (AllStudents?, Error?)-> Void){
 let url = ParseClient.Endpoints.studentLocation.url
 var request = URLRequest(url: url)
 
 request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
 request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
 
 
 let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
 guard let dataObject = data else {return}
 //            print(String(data: dataObject, encoding: .utf8)!)
 //            print("temp")
 do {
 let allStudentsObject = try JSONDecoder().decode(AllStudents.self, from: dataObject)
 print(allStudentsObject)
 completion(allStudentsObject, nil)
 } catch {
 DispatchQueue.main.async {
 completion(nil, error)
 }
 }
 }
 task.resume()
 }
 */

//    class func getAllStudents(completion: @escaping (AllStudents?, Error?)-> Void){
//        let url = ParseClient.Endpoints.studentLocation.url
//        var request = URLRequest(url: url)
//
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let dataObject = data else {return}
//            //            print(String(data: dataObject, encoding: .utf8)!)
//            //            print("temp")
//            do {
//                let allStudentsObject = try JSONDecoder().decode(AllStudents.self, from: dataObject)
//                print(allStudentsObject)
//                DispatchQueue.main.async {
//                    completion(allStudentsObject, nil)
//                }
//                return
//            } catch {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//                return
//            }
//        }
//        task.resume()
//    }
