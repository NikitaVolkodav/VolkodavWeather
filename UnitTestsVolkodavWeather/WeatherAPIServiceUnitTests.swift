//
//  WeatherAPIServiceUnitTests.swift
//  UnitTestsVolkodavWeather
//
//  Created by Nikita Volkodav on 27.02.2023.
//

import XCTest
@testable import VolkodavWeather

final class WeatherAPIServiceUnitTests: XCTestCase {

    var weatherAPIService: WeatherAPIService!

    override func setUp() {
        super.setUp()
        weatherAPIService = WeatherAPIService()
    }

    override func tearDown() {
        weatherAPIService = nil
        super.tearDown()
    }
    
    func testFetchGeolocationWeatherSuccessfully()  {
        let expectation = self.expectation(description: "Weather model returned")

        weatherAPIService.fetchGeolocationWeather(latitude: 51.5085, longitude: -0.12574) { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result.name, "London")
            XCTAssertEqual(result.sys.country, "GB")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchCityWeatherSuccessfully() {
        
        let expectation = self.expectation(description: "Weather model returned")
        weatherAPIService.fetchCityWeather(cityName: "Kyiv") { result, error in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(result!.name, "Kyiv")
            XCTAssertEqual(result!.sys.country, "UA")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchWeatherImageForWeatherIdSuccessfully() {

        XCTAssertEqual(WeatherImage(weatherId: 200).weatherName, "cloud.bolt.fill")
        XCTAssertEqual(WeatherImage(weatherId: 300).weatherName, "cloud.drizzle.fill")
        XCTAssertEqual(WeatherImage(weatherId: 500).weatherName, "cloud.rain.fill")
        XCTAssertEqual(WeatherImage(weatherId: 600).weatherName, "cloud.snow.fill")
        XCTAssertEqual(WeatherImage(weatherId: 701).weatherName, "cloud.fog.fill")
        XCTAssertEqual(WeatherImage(weatherId: 800).weatherName, "sun.max.fill")
        XCTAssertEqual(WeatherImage(weatherId: 801).weatherName, "cloud.fill")
        XCTAssertEqual(WeatherImage(weatherId: 999).weatherName, "cloud.fill")
    }

}
