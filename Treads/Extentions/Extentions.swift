//
//  Extentions.swift
//  Treads
//
//  Created by Odhrán Daly on 10/08/2019.
//  Copyright © 2019 Odhrán Daly. All rights reserved.
//

import Foundation

extension Double {
    
    func mettersToMiles(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ((self / 1609.34) * divisor).rounded() / divisor
    }
}

extension Int {
    func formatTimeDurationToString() -> String {
        let durationHours = self / 3600
        let durationMinutes = (self % 3600) / 60
        let duratinSecond = (self % 3600) % 60
        
        if duratinSecond < 0 {
            return "00:00:00"
        } else {
            if durationHours == 0 {
                return String(format: "%02d:%02d", durationMinutes, duratinSecond)
            } else {
                return String(format: "%02d:%02d:%02d", durationHours, durationMinutes, duratinSecond)
            }
        }
    }
}

extension NSDate {
    func getDateString() -> String {
        let calandar = Calendar.current
        let month = calandar.component(.month, from: self as Date)
        let day = calandar.component(.day, from: self as Date)
        let year = calandar.component(.year, from: self as Date)
        
        return "\(day)/\(month)/\(year))"
    }
}
