//
//  Weather.swift
//  Weather App
//
//  Created by Allen Czerwinski on 2/23/16.
//  Copyright © 2016 Allen Czerwinski. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    private var _conditions: String!
    private var _temperature: String!
    private var _day: String!
    private var _date: String!
    private var _time: String!
    private var _sunrise: String!
    private var _sunset: String!
    private var _humidity: String!
    private var _windSpeed: String!
    private var _windDirection: WindDirection!
    
    private var _weatherURL: String!
    
    enum WindDirection {
        case N
        case NE
        case E
        case SE
        case S
        case SW
        case W
        case NW
        case NA
    }
    
    var conditions: String {
        if _conditions == nil {
            _conditions = ""
        }
        return _conditions
    }
    
    var temperature: String {
        if _temperature == nil {
            _temperature = ""
        }
        return _temperature
    }
    
    var day: String {
        if _day == nil {
            _day = ""
        }
        return _day
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var time: String {
        if _time == nil {
            _time = ""
        }
        return _time
    }
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    
    var humidity: String {
        if _humidity == nil {
            _humidity = ""
        }
        return _humidity
    }
    
    var windSpeed: String {
        if _windSpeed == nil {
            _windSpeed = ""
        }
        return _windSpeed
    }
    
    var windDirection: WindDirection {
////        get {
////            return _windDirection
////        }
//        if _windDirection == nil {
//            _windDirection = WindDirection.NA
//        }
        get {
            return _windDirection
        }
    }
    
    init() {
        self._weatherURL = URL_BASE
    }
    
//    init(conditions: String, temperature: Int) {
//        self._conditions = conditions
//        self._temperature = temperature
//        
//        self._weatherURL = "\(URL_BASE)"
//    }
    
    func downloadWeatherDetails(completed: DownloadComplete) {
        let url = NSURL(string: _weatherURL)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weather = dict["weather"] as? [AnyObject] where weather.count > 0 {
                    if let conditions = weather[0]["main"] as? String {
                        self._conditions = conditions
                    }
                    
                    print(self._conditions)
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> where main.count > 0 {
                    if let temperature = main["temp"] as? Double {
                        let temp = 1.8 * (temperature - 273) + 32
                        
                        let formattedTemp = NSString(format: "%.0f", temp)
                        self._temperature = formattedTemp as String
                        
                    }
                    print(self._temperature)
                }
                
                if let dateToday = dict["dt"] as? Double {
                    let date = NSDate(timeIntervalSince1970: dateToday)
                    let dayFormatter = NSDateFormatter()
                    let dateFormatter = NSDateFormatter()
                    let timeFormatter = NSDateFormatter()
                    dayFormatter.dateFormat = "EEEE"
                    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                    timeFormatter.dateFormat = "h:mm a"
                    self._day = dayFormatter.stringFromDate(date)
                    self._date = dateFormatter.stringFromDate(date)
                    self._time = timeFormatter.stringFromDate(date)
                }
                
                if let sunRiseSet = dict["sys"] as? Dictionary<String, AnyObject> where sunRiseSet.count > 0 {
                    if let sunrise = sunRiseSet["sunrise"] as? Double {
                        let date = NSDate(timeIntervalSince1970: sunrise)
                        let timeFormatter = NSDateFormatter()
                        timeFormatter.dateFormat = "h:mma"
                        self._sunrise = timeFormatter.stringFromDate(date)
                    }
                    
                    if let sunset = sunRiseSet["sunset"] as? Double {
                        let date = NSDate(timeIntervalSince1970: sunset)
                        let timeFormatter = NSDateFormatter()
                        timeFormatter.dateFormat = "h:mma"
                        self._sunset = timeFormatter.stringFromDate(date)
                    }
                }
                
                if let isItHumid = dict["main"] as? Dictionary<String, AnyObject> where isItHumid.count > 0 {
                    if let humidity = isItHumid["humidity"] as? Double {
                        let formattedHumidity = NSString(format: "%0.f", humidity)
                        self._humidity = formattedHumidity as String
                    }
                }
                
                if let windInfo = dict["wind"] as? Dictionary<String, AnyObject> where windInfo.count > 0 {
                    if let wind = windInfo["speed"] as? Double {
                        let formattedWindSpeed = NSString(format: "%0.f", wind)
                        self._windSpeed = formattedWindSpeed as String
                    }
                    
                    if let direction = windInfo["deg"] as? Double {
                        switch(direction) {
                        case 337.5...360:
                            self._windDirection = WindDirection.N
                        case 0..<22.5:
                            self._windDirection = WindDirection.N
                        case 22.5..<67.5:
                            self._windDirection = WindDirection.NE
                        case 67.5..<112.5:
                            self._windDirection = WindDirection.E
                        case 112.5..<157.5:
                            self._windDirection = WindDirection.SE
                        case 157.5..<202.5:
                            self._windDirection = WindDirection.S
                        case 202.5..<247.5:
                            self._windDirection = WindDirection.SW
                        case 247.5..<292.5:
                            self._windDirection = WindDirection.W
                        case 292..<337.5:
                            self._windDirection = WindDirection.NW
                        default:
                            self._windDirection = WindDirection.NA
                        }
                    }
                }
                
            }
            
            
            
            
            
            
            
            completed()
        }
    }
    
    
}
