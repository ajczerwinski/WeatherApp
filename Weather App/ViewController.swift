//
//  ViewController.swift
//  Weather App
//
//  Created by Allen Czerwinski on 2/22/16.
//  Copyright © 2016 Allen Czerwinski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var conditionsUI: UILabel!
    @IBOutlet weak var temperatureUI: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var windDirectionLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var refreshButtonUI: UIButton!

    
    var weather: Weather!

    override func viewDidLoad() {
        super.viewDidLoad()
        background.alpha = 0.4
        headerView.alpha = 1.0
        
        weather = Weather()
        weather.downloadWeatherDetails { () -> () in
            self.updateUI()
        }
        refreshButtonUI.hidden = true
    }
    
    func updateUI() {
        
        conditionsUI.text = weather.conditions
        switch weather.conditions {
            case "Rain":
                weatherIcon.image = UIImage(named: "rain")
            case "Thunderstorm":
                weatherIcon.image = UIImage(named: "thunderstorm")
            case "Drizzle":
                weatherIcon.image = UIImage(named: "rain")
            case "Snow":
                weatherIcon.image = UIImage(named: "snow")
            case "Atmosphere":
                weatherIcon.image = UIImage(named: "cloud")
            case "Clear":
                weatherIcon.image = UIImage(named: "clear")
            default:
                weatherIcon.image = UIImage(named: "cloud")
            
        }
        temperatureUI.text = "\(weather.temperature)°F"
        dateLbl.text = "last updated \(weather.time) \(weather.day) \(weather.date)"
        sunriseLbl.text = weather.sunrise
        sunsetLbl.text = weather.sunset
//        print(weather.humidity)
        humidityLbl.text = "Relative Humidity: \(weather.humidity)%"
        windSpeedLbl.text = "\(weather.windSpeed) MPH"
        windDirectionLbl.text = "\(weather.windDirection)"
        
    }
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        weather.downloadWeatherDetails { () -> () in
            self.updateUI()
        }
    }

}

