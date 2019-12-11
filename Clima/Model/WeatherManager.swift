//
//  WeatherManager.swift
//  Clima
//
//  Created by Baris Uectas on 11.12.19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=16d17590a76b540494386a27cc384898&units=metric"
    
    func fetchWeather(cityName: String){
        let urlString = "\(url)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, res, err) in
                if err != nil{
                    print(err!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.weather[0].description)
        }catch{
            print(error)
        }
    }
    
    
}
