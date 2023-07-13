//
//  WeatherModel.swift
//  Clima
//
//  Created by Yogalakshmi Balasubramaniam on 5/30/23.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6c3958338464ec0e3660b37a1ac86397&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityname: String) {
        let urlString = "\(weatherURL)&q=\(cityname)"
        performRequest(with: urlString)
    }
    
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        print(urlString)
        // 1. Create URL Obj
        if let url = URL(string: urlString) {
            // 2. Create URLSession obj
            let session = URLSession(configuration: .default)
            print("In performRequest")
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, urlResponse, error in
                if let e = error {
                    delegate?.didFailWithError(error: e)
                } else {
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            print(decodedData.weather[0].id)
            let id = decodedData.weather[0].id
            let weatherModel = WeatherModel(conditionId: id , temperature: temp, cityName: name)
            return weatherModel
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}

