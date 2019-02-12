//
//  ActivityIndicatorSingleton.swift
//  _OnTheMap
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

//Both List & MapController supply delgates to the MainTabController
//MainTabController is now able to start/stop UIActivityIndicators on each tab simulatenously.

class ActivityIndicatorSingleton{
    static let shared = ActivityIndicatorSingleton()
    var mapDelegate: MapControllerDelegate?
    var AnnotationTableDelegate: AnnotationTableControllerDelegate?
}
