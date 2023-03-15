//
//  weatherData.swift
//  Clima
//
//  Created by Андрей Логвинов on 2/13/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData:Decodable{
    let name: String
    let main :Main
    let weather: [Weather]
    let wind: Wind
}
struct Main: Decodable{
    let temp: Double
}

struct Weather: Decodable{
    let description: String
    let id: Int
}
struct Wind: Decodable{
    let speed: Double
}
