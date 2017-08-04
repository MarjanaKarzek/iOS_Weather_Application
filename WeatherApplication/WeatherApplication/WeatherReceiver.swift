//
//  WeatherReceiver.swift
//  WeatherApplication
//
//  Created by Marjana Karzek on 04/08/17.
//  Copyright © 2017 Marjana Karzek. All rights reserved.
//

import Foundation

class WeatherReceiver{
    
    //api call http://api.openweathermap.org/data/2.5/forecast/daily?lat=35&lon=139&cnt=10&APPID=a7bffb57677f99b143e633c566b43794
    let address = "http://api.openweathermap.org/data/2.5/forecast/daily?"
    let key = "a7bffb57677f99b143e633c566b43794"
    
    var json: [String: Any] = [:]
    
    var weatherCards = [WeatherCard]()
    
    func callWeatherdata(latitude: Double, longitude: Double, forecast: Int, completed: @escaping () -> ()) {
        //print("made it to the call")
        let apicall = "\(address)lat=\(latitude)&lon=\(longitude)&cnt=\(forecast)&APPID=\(key)"
        
        if let url = URL(string: apicall){
            //print("calling for \(latitude) \(longitude) \(forecast)")
            //print("url " + apicall)
            let dataCallTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print("error on getting data from url")
                    } else {
                        if let jsondata = data{
                            print("data received")
                            do {
                                self.json = try JSONSerialization.jsonObject(with: jsondata) as! [String: Any]
                                print("json found")
                                //self.extractData()
                                completed()
                            } catch {
                                print("error on JSONSerialization")
                                completed()
                            }
                        }
                    }
                }
                dataCallTask.resume()
        }
    }
    
    func extractData(completed: () -> ()){
        weatherCards.removeAll()
        let list = json["list"] as! [[String: Any]]
            
        for date in list {
            //print(date)
            var card = WeatherCard()
            
            if let dt = date["dt"] as? Int {
                card.dt = dt
            }
            if let clouds = date["clouds"] as? Int {
                card.clouds = clouds
            }
            if let pressure = date["pressure"] as? Float {
                card.pressure = pressure
            }
            if let humidity = date["humidity"] as? Int {
                card.humidity = humidity
            }
            if let speed = date["speed"] as? Float {
                card.speed = speed
            }
            if let deg = date["deg"] as? Int {
                card.deg = deg
            }
            
            let temp = date["temp"] as! NSDictionary
            var day = 0
            var min = 0
            var max = 0
            var night = 0
            var eve = 0
            var morn = 0
            if let dayValue = temp["day"] as? Int {
                day = dayValue
            }
            if let minValue = temp["min"] as? Int {
                min = minValue
            }
            if let maxValue = temp["max"] as? Int {
                max = maxValue
            }
            if let nightValue = temp["night"] as? Int {
                night = nightValue
            }
            if let eveValue = temp["eve"] as? Int {
                eve = eveValue
            }
            if let mornValue = temp["morn"] as? Int {
                morn = mornValue
            }
            card.temp = (day, min, max, night, eve, morn)
            
            let weather = date["weather"] as! [[String:Any]]
            var main = ""
            var icon = ""
            var description = ""
            var id = 0
            for weatherinfo in weather{
                for data in weatherinfo {
                    switch (data.key){
                        case "main":
                            main = data.value as! String
                            break
                        case "icon":
                            icon = data.value as! String
                            break
                        case "description":
                            description = data.value as! String
                            if description == "sky is clear"{
                                description = "clear sky"
                            }
                            break
                        default:
                            id = data.value as! Int
                    }
                }
                card.weather = (id,main,description,icon)
            }
            card.toString()
            weatherCards.append(card)
        }
        completed()
    }
    
    func getWeatherIcon(id: Int) -> String{
        let weatherType = id / 100
        var imageSource = ""
        switch (weatherType){
            case 2:
                //thunder
                imageSource = "001lighticons-26.png"
                break
            case 4:
                //drizzle
                imageSource = "001lighticons-17.png"
                break
            case 5:
                //rainy
                imageSource = "001lighticons-18.png"
                break
            case 6:
                //snowy
                imageSource = "001lighticons-23.png"
                break
            case 7:
                //foggy
                imageSource = "001lighticons-13.png"
                break
            case 8:
                //sunny
                imageSource = "001lighticons-2.png"
                break
            default:
                //cloudy
                imageSource = "001lighticons-14.png"
        }
        return imageSource
    }
}
