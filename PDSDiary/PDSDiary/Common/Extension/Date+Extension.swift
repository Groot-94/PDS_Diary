//
//  Date+Extension.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/05.
//

import Foundation

extension Date {
    func convert() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: self)
    }
    
    func convertCurrenDate() -> Date {
        let date = Date()
        let year = Calendar.current.dateComponents([.year], from: self)
        let month = Calendar.current.dateComponents([.month], from: self)
        let day = Calendar.current.dateComponents([.day], from: self)
        let hour = Calendar.current.dateComponents([.hour], from: date)
        let minute = Calendar.current.dateComponents([.minute], from: date)
        let second = Calendar.current.dateComponents([.second], from: date)
        
        let dateComponents = DateComponents(timeZone: nil ,
                                            year: year.year,
                                            month: month.month,
                                            day: day.day,
                                            hour: hour.hour,
                                            minute: minute.minute,
                                            second: second.second)
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}
