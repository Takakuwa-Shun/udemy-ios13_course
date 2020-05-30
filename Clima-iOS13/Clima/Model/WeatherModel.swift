//
//  WeatherModel.swift
//  Clima
//
//  Created by 高桑駿 on 2020/03/21.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    var temperatureString: String {
        return String.init(format: "%.1f", temperature - 273.15)
    }
    
    var conditionName: String {
        switch conditionId {
            case 200 ... 232:
                // Thunderstorm
                return "cloud.bolt.rain"
            case 300 ... 321:
                // Drizzle
                return "cloud.drizzle"
            case 500 ... 531:
                // Rain
                return "cloud.heavyrain"
            case 600 ... 622:
                // Snow
                return "snow"
            case 800:
                // Clear
                return "sun.max"
            case  801 ... 804:
                // Clouds
                return "cloud"
            default:
                return "cloud"
            }
    }
}
