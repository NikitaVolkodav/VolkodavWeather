//
//  DateService.swift
//  VolkodavWeather
//
//  Created by Nikita Volkodav on 11.02.2023.
//

import Foundation

struct DateService {
    
    func fetchDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdYYYY")
        return dateFormatter.string(from: date)
    }
}
