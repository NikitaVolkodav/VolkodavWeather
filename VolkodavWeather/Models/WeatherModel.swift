//
//  WeatherModel.swift
//  VolkodavWeather
//
//  Created by Nikita Volkodav on 11.02.2023.
//

import Foundation

struct WeatherModel: Codable {
    var weather: [Weather] = []
    var main: Temperature = Temperature()
    var sys: Country = Country()
    var name: String = ""
    
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
}

struct Temperature: Codable {
    var temperatureNow: Double = 0.0
    var temperatureMin: Double = 0.0
    var temperatureMax: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case temperatureNow = "temp"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
    }
    
}

struct Country: Codable {
    var country: String = ""
}
