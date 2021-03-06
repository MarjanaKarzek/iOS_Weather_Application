//
//  User.swift
//  WeatherApplication
//
//  Created by Marjana on 07.08.17.
//  Copyright © 2017 Marjana Karzek. All rights reserved.
//

import Foundation

class User {
    let id:Int64
    var username:String
    var password:String
    var name:String
    var homelocation:String
    var previewAmount:Int64
    var selectedLatitude:Double
    var selectedLongitude:Double
    
    init(id: Int64, username: String, password: String, name: String, homelocation: String, previewAmount: Int64, selectedLatitude: Double, selectedLongitude: Double){
        self.id = id
        self.username = username
        self.password = password
        self.name = name
        self.homelocation = homelocation
        self.previewAmount = previewAmount
        self.selectedLatitude = selectedLatitude
        self.selectedLongitude = selectedLongitude
    }
}
