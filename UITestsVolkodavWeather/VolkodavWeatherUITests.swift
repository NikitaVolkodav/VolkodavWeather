//
//  VolkodavWeatherUITests.swift
//  UITestsVolkodavWeather
//
//  Created by Nikita Volkodav on 27.02.2023.
//

import XCTest

final class VolkodavWeatherUITests: XCTestCase {

    func testWhereShowsWeatherFromCityNameSuccessfully() {
        let app = XCUIApplication()
        app.launch()
        
        let locationDialogMonitor = addUIInterruptionMonitor(withDescription: "Location Permission Alert") { (alertElement) -> Bool in
            let partialPermissionMessage = "to use your location?"
            if alertElement.labelContains(text: partialPermissionMessage) {
                alertElement.buttons["Don’t Allow"].tap()
                return true
            }
            return false
        }
      
        app.buttons["Search city"].tap()
        let textField = app.textFields["Search Text Field"]
        textField.tap()
        textField.typeText("Kharkiv\n")
        
        XCTAssertTrue(app.staticTexts["Temperature Label"].exists)
        XCTAssertTrue(app.staticTexts["Temperature minimum"].exists)
        XCTAssertTrue(app.staticTexts["Temperature maximum"].exists)
        XCTAssertTrue(app.staticTexts["Date Label"].exists)

        XCTAssertTrue(app.staticTexts["Description Label"].exists)
        XCTAssertTrue(app.staticTexts["City Label"].exists)
        XCTAssertTrue(app.staticTexts["Kharkiv"].exists)
        
        self.removeUIInterruptionMonitor(locationDialogMonitor)
    }
}

extension XCUIElement {
    func labelContains(text: String) -> Bool {
        let predicate = NSPredicate(format: "label CONTAINS %@", text)
        return staticTexts.matching(predicate).firstMatch.exists
    }
    
}
