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
}
