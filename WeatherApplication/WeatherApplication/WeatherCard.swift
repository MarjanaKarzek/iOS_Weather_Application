//
//  WeatherCard.swift
//  WeatherApplication
//
//  Created by Marjana Karzek on 04/08/17.
//  Copyright © 2017 Marjana Karzek. All rights reserved.
//

import Foundation

struct WeatherCard {
    var dt: Int
    var temp: (day: Int, min: Int, max: Int, night: Int, eve: Int, morn: Int)
    var pressure: Float
    var humidity: Int
    var weather: (id: Int, main: String, description: String, icon: String)
    var speed: Float
    var deg: Int
    var clouds: Int
    
    init(){
        self.dt = 0
        self.temp = (0, 0, 0, 0, 0, 0)
        self.pressure = 0.0
        self.humidity = 0
        self.weather = (0, "", "", "")
        self.speed = 0.0
        self.deg = 0
        self.clouds = 0
    }
    
    init(dt:Int, day:Int, min:Int, max: Int, night: Int, eve: Int, morn: Int, pressure: Float, humidity: Int, id:Int, main:String, description: String, icon: String, speed:Float, deg: Int, clouds: Int){
        self.dt = dt
        self.temp = (day, min, max, night, eve, morn)
        self.pressure = pressure
        self.humidity = humidity
        self.weather = (id, main, description, icon)
        self.speed = speed
        self.deg = deg
        self.clouds = clouds
    }
}
