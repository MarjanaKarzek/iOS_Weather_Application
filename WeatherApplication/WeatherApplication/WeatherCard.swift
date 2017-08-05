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
    
    var temperature: String {
        return "\(temp.min-273) - \(temp.max-273)°C"
    }
    var date: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return "\(day)-\(month)-\(year)"
    }
    var text: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let dayExtention = getDayExtention(number: day)
        let month = getMonth(number: calendar.component(.month, from: date))
        if temp.min == temp.max {
            return "The Weather on the \(day)\(dayExtention) of \(month) will be \(weather.description) with \(temp.min-273) degrees."
        }
        else {
            return "The Weather on the \(day)\(dayExtention) of \(month) will be \(weather.description) with \(temp.min-273) to \(temp.max-273) degrees."
        }
    }
    
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
    
    func getDayExtention(number: Int) -> String{
        var extention = ""
        switch (number){
            case 1, 21, 31:
                extention = "st"
                break
            case 2, 22:
                extention = "nd"
                break
            case 3, 23:
                extention = "rd"
                break
            default:
                extention = "th"
        }
        return extention
    }
    
    func getMonth(number: Int) -> String{
        var month = ""
        switch (number){
            case 1:
                month = "January"
            break
        case 2:
            month = "Febuary"
            break
        case 3:
            month = "March"
            break
        case 4:
            month = "April"
            break
        case 5:
            month = "Mai"
            break
        case 6:
            month = "June"
            break
        case 7:
            month = "July"
            break
        case 8:
            month = "August"
            break
        case 9:
            month = "September"
            break
        case 10:
            month = "Oktober"
            break
        case 11:
            month = "November"
            break
        default:
            month = "Dezember"
        }
        return month
    }
    
    func toString(){
        print("\(dt) \(pressure) \(humidity) \(speed) \(deg) \(clouds)")
        print("\(temp.day) \(temp.min) \(temp.max) \(temp.night) \(temp.eve) \(temp.morn)")
        print("\(weather.id) \(weather.main) \(weather.description) \(weather.icon)")
        print("\(temperature)")
        print("\(date)")
        print("\(text)")
    }
}
