//
//  WeatherAPIService.swift
//  VolkodavWeather
//
//  Created by Nikita Volkodav on 16.02.2023.
//

import Foundation

struct WeatherAPIService {
    
    func fetchGeolocationWeather(latitude: Double, longitude: Double,_ completion: @escaping (WeatherModel) -> Void ) {
       let urlString =  "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longitude.description)&units=metric&appid=f548aecaab0b491591a701a6ca6cd84a"
        performRequest(with: urlString) { result, error  in
            guard let result = result else { return }
                  completion(result)
            }
    }
    
    func fetchCityWeather(cityName: String,_ completion: @escaping (WeatherModel?,_ error: Error?) -> Void ) {
        let urlString =  "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=metric&appid=f548aecaab0b491591a701a6ca6cd84a"
        performRequest(with: urlString) { result, error  in
            if let result = result {
                completion(result, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
   private func performRequest(with urlString: String,_ completion: @escaping (WeatherModel?,_ error: Error?)-> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let parsingData = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(parsingData, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
        .resume()
    }
}
