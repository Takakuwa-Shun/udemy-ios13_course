//
//  WeatherManager.swift
//  Clima
//
//  Created by 高桑駿 on 2020/03/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather : WeatherModel) -> Void
    func didFailWithError(error: Error) -> Void
}

struct WeatherManager {
    let weatherURL = "https://samples.openweathermap.org/data/2.5/weather?appid=b6907d289e10d714a6e88b30761fae22"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(longtitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longtitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    self.delegate?.didFailWithError(error: err)
                    return
                }
                
                guard let safeData = data else {
                    return
                }
                
                if let stringData = String(data: safeData, encoding: .utf8) {
                    print(stringData)
                }
                self.parseJSON(safeData)
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weatherId = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            let weatherModel = WeatherModel(conditionId: weatherId, cityName: cityName, temperature: temp)
            delegate?.didUpdateWeather(self, weather: weatherModel)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
}
