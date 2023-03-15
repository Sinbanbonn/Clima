//
//  whetherManager.swift
//  Clima
//
//  Created by Андрей Логвинов on 2/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel)
}


//protocol CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//}

struct WeatherManager{
    let whetherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1a890d589a0caf1c836ab7e8efc439b8&units=metric"
    var delegate: WeatherManagerDelegate?
    //var geoDelegate: CLLocationManagerDelegate?
    
    
    func fetchWeather(name:String){
        let url = "\(whetherURL)&q=\(name)"
        print(url)
        performRequest(url)
    }
    
    func fetchWeather(lot: CLLocationDegrees , lon: CLLocationDegrees){
        let url = "\(whetherURL)&lat=\(lot)&lon=\(lon)"
        print(url)
        performRequest(url)
        
    }
    
    
    func performRequest(_ urlString:String){
        let url = URL(string: urlString)

        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url!){ (data, response, error) in

            if error != nil{
                print(error!)
                return
            }
            if let safeData = data {
                //let newValue = String(data: safeData, encoding: .utf8)
                //print(newValue)
                if  let weather =  self.parseJson(weatherData: safeData) {
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }

            }



        }

        task.resume()
        
        
        
    }
    
    func parseJson(weatherData: Data)->WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData )
            //            print("\(decodedData.name) -- \(decodedData.main.temp) -- \(decodedData.weather[0].description) -- \(decodedData.wind.speed)")
            let name = decodedData.name
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let weather = WeatherModel(conditionalId: id, name: name, temperature: temp)
            return weather
            
        }
        catch{
            print(error)
            return nil
        }
        
    }
    
}
