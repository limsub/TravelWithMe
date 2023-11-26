//
//  Date+Extension.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import Foundation

extension Date {
    var convertedDate: Date {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyy.MM.dd HH:mm"
        dateFormatter.dateFormat = dateFormat
        let formattedDate = dateFormatter.string(from: self)

        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")

        dateFormatter.dateFormat = dateFormat
        let sourceDate = dateFormatter.date(from: formattedDate)

        return sourceDate!
    }
}
