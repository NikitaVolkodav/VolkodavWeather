//
//  MainViewController.swift
//  VolkodavWeather
//
//  Created by Nikita Volkodav on 10.02.2023.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak private var geolocationButton: UIButton!
    @IBOutlet weak private var searchCityTextField: UITextField!
    @IBOutlet weak private var searchButton: UIButton!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var presentDayLabel: UILabel!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var minimumTemperatureLabel: UILabel!
    @IBOutlet weak private var maximumTemperatureLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var imageWeather: UIImageView!
    
    private let locationManager = CLLocationManager()
    private let weatherAPIService = WeatherAPIService()
    private let dateService = DateService()
    private var weatherModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        guard locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways else { return }
        
        DispatchQueue.global().async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                locationManager.pausesLocationUpdatesAutomatically = false
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    private func updateWeatherLabels() {
        let temperatureDoubleToString = String(format: "%.0f", weatherModel.main.temperatureNow)
        let minTemperatureDoubleToString = String(format: "%.0f", weatherModel.main.temperatureMin)
        let maxTemperatureDoubleToString = String(format: "%.0f", weatherModel.main.temperatureMax)
        guard let weatherModelWeatherFirstDescription = weatherModel.weather.first?.description else { return}
        cityLabel.text = weatherModel.name
        descriptionLabel.text = weatherModelWeatherFirstDescription
        temperatureLabel.text = temperatureDoubleToString
        presentDayLabel.text = dateService.fetchDate()
        minimumTemperatureLabel.text = minTemperatureDoubleToString
        maximumTemperatureLabel.text = maxTemperatureDoubleToString
    }
    
    private func updateWeatherImage() {
        guard let weatherModelWeatherFirstId = weatherModel.weather.first?.id else { return }
        let image = WeatherImage(weatherId: weatherModelWeatherFirstId)
        imageWeather.image = UIImage(systemName: image.weatherName)
    }
    
    private func invalidAlertCity() {
        let alertController = UIAlertController(title: "Invalid city", message: "Enter a valid city", preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertOkAction)
        present(alertController, animated: true)
    }
    
    private func errorAlertIfGeolocationInvalid() {
        let alertController = UIAlertController(title: "Error", message: "Click on the geolocation icon", preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertOkAction)
        present(alertController, animated: true)
    }
    
    @IBAction private func locationPressed(_ sender: UIButton) {
        startLocationManager()
        searchCityTextField.isHidden = true
    }
    
    @IBAction private func activateSearchTextField(_ sender: UIButton) {
        searchCityTextField.isHidden.toggle()
    }
}

extension MainViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            locationManager.stopUpdatingLocation()
            weatherAPIService.fetchGeolocationWeather(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude) { result in
                self.weatherModel = result
                DispatchQueue.main.async { [self] in
                    updateWeatherLabels()
                    updateWeatherImage()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        errorAlertIfGeolocationInvalid()
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchCityTextField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchCityTextField.text {
            weatherAPIService.fetchCityWeather(cityName: city) { result, error in
                if error != nil {
                    DispatchQueue.main.async { [self] in
                        invalidAlertCity()
                    }
                } else {
                    guard let result = result else { return }
                    self.weatherModel = result
                    DispatchQueue.main.async { [self] in
                        updateWeatherLabels()
                        updateWeatherImage()
                    }
                }
            }
        }
        searchCityTextField.text = ""
    }
}
