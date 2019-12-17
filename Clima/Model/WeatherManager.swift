//
//  WeatherManager.swift
//  Clima
//
//  Created by Baris Uectas on 11.12.19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=16d17590a76b540494386a27cc384898&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(url)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latidude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(url)&lat=\(latidude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, res, err) in
                if err != nil{
                    self.delegate?.didFailWithError(error: err!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(weatherId: id, cityName: name, temperature: temp)
            return weather
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
