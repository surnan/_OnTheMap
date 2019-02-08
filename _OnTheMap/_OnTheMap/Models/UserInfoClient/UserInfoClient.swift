//
//  UserInfoClient.swift
//  _OnTheMap
//
//  Created by admin on 2/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


class UserInfoClient {
    static var uniqueKey: String {
        return UdacityClient.getAccountKey()
    }
    
    
    static var firstName = "John"
    static var lastName = "Snow"
    static var mapString = ""
    static var mediaURL = ""
    static var longitude = 0.0
    static var latitude = 0.0
    
    
    class func setMapString(map: String){
        UserInfoClient.mapString = map
    }
    
    class func setMediaURL(url: String){
        UserInfoClient.mediaURL = url
    }
    
    
    class func setupFromAnnotationController(mapString: String, mediaURL: String, longitude: Double, latitude: Double){
        UserInfoClient.mapString = mapString
        UserInfoClient.mediaURL = mediaURL
        UserInfoClient.longitude = longitude
        UserInfoClient.latitude = latitude
    }
    
    
    class func getUserInfoClient()->(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, longitude: Double, latitude: Double){
        return ( uniqueKey  , firstName, lastName, mapString, mediaURL, longitude, latitude )
    }
}
