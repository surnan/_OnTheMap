//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//case studentLocation

import Foundation

class ParseClient {
    
    private static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    private enum Endpoints{
        static let base = "https://parse.udacity.com/parse/classes"
        case postStudentLocation
        case putStudentLocation(String)
        case getStudentsSortedByCreationDate(Int)
        case getPublicInfo(String)
        
        var toString: String {
            switch self {
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .putStudentLocation(let objectID): return Endpoints.base + "/StudentLocation/" + objectID
            case .getStudentsSortedByCreationDate(let countRequest): return Endpoints.base
                + "/StudentLocation?limit=\(countRequest)"
                + "&order=-updatedAt"
            case .getPublicInfo(let key): return Endpoints.base
                + "/StudentLocation"
                + "?where=%7B%22"
                + "uniqueKey%22%3A%22"
                + "\(key)"
                + "%22%7D"
                
            }
        }
        
        var url: URL {
            return URL(string: toString)!
        }
    }
    
    //MARK:- PUT
    class func putStudentLocation(objectID: String, firstname: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?)->Void)-> URLSessionTask?{
        let _StudentLocationRequest = PostPutRequest(
            firstName: firstname,
            lastName: lastName,
            latitude: latitude,
            longitude: longitude,
            mapString: mapString,
            mediaURL: mediaURL,
            uniqueKey: UdacityClient.getAccountKey())
        
        let task = taskForPutRequest(url: Endpoints.putStudentLocation(objectID).url, encodable: _StudentLocationRequest) { (success, err) in
            if success {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                return
            } else {
                DispatchQueue.main.async {
                    completion(false, err)
                }
                print("taskForPut FAILED:\n\n\n \(String(describing: err)) \n\n\n \(String(describing: err?.localizedDescription))")
                return
            }
        }
        task?.resume()
        return task
    }
    
    private class func taskForPutRequest(url: URL, encodable: PostPutRequest, completion: @escaping (Bool, Error?)->Void )->URLSessionTask?{
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = putTimeOut
        
        do {
            let body = try JSONEncoder().encode(encodable)
            request.httpBody = body
        } catch {
            print("taskForPutRequest - unable to encode")
            DispatchQueue.main.async {
                completion(false, error)
            }
            return nil
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            }
            task.resume()
        return task
    }
    
    
    
    
    
    //MARK:- GET
    class func getStudents(completion: @escaping ([StudentLocation], Error?)-> Void)-> URLSessionTask{
        let url = ParseClient.Endpoints.getStudentsSortedByCreationDate(100).url
        let task = taskForGetRequest(url: url, decoder: StudentLocationResultsResponse.self) { (data, err) in
            if err != nil {
                return completion([], err)
            }
            guard let data = data else {return}
            completion(data.results, nil)
            return
        }
        return task
    }
    
    @discardableResult class private func taskForGetRequest<Decoder: Decodable>(url: URL, decoder: Decoder.Type, completion: @escaping (Decoder?, Error?)-> Void) -> URLSessionTask{
        var request = URLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        //        request.timeoutInterval = 25
        request.timeoutInterval = downloadStudentLocationsTimeOut
        
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
    
    //MARK:- POST
    class func postStudentLocation(firstname: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (PostPushResponse?, Error?)->Void)-> URLSessionTask?{
        let _StudentLocationRequest = PostPutRequest(firstName: firstname,
                                                     lastName: lastName,
                                                     latitude: latitude,
                                                     longitude: longitude,
                                                     mapString: mapString,
                                                     mediaURL: mediaURL,
                                                     uniqueKey: UdacityClient.getAccountKey())
        
        
        
        let task = taskForPostRequest(url: Endpoints.postStudentLocation.url, body: _StudentLocationRequest, decodeType: PostPushResponse.self) { (data, error) in
            if let err = error {
                completion(nil, err)
                return
            }
            guard let data = data else {
                print("Data returned from taskForPostRequest is nil and returned error was also nil")
                completion(nil, error)
                return
            }
            completion(data, nil)
            return
        }
        return task
    }
    
    private class func taskForPostRequest<Encoding: Encodable, Decoder: Decodable>(url: URL, body: Encoding, decodeType: Decoder.Type, completion: @escaping (Decoder?, Error?)->Void) -> URLSessionTask? {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.timeoutInterval = postTimeOut
        
        do {
            let body =  try JSONEncoder().encode(body)
            request.httpBody =   body
        } catch {
            print("Unable to encode JSON Body for ParseClient.PostStudentLocation with StudentLocationRequest object")
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return nil
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
        }
        task.resume()
        return task
    }
    
    
    
    
    //MARK:- Get Only One Location - Used to setup PUT input
    class func getOneStudentLocation(key: String, completion: @escaping (StudentLocationResultsResponse?, Error?)-> Void ){
        let url = Endpoints.getPublicInfo(key).url
        taskForGetRequest(url: url, decoder: StudentLocationResultsResponse.self) { (data, err) in
            guard let object = data else {
                completion(nil, err)
                return
            }
            completion(object, nil)
            return
        }
    }
    
}


