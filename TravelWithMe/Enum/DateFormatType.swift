//
//  DateType.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import Foundation

enum DateFormatType: String {
    
    case full = "yyyyMMdd"
    case fullWithDot = "yyyy. MM. dd"
    case monthSlashDay = "M/d"
    case yearMonthDaySlash = "yy/M/d"
    
    case yearMonth = "yyyyMM"
    
    case fullMonth = "MMMM"
    case fullYear = "yyyy"
    
    case day = "d"
    
    case koreanFullString = "yyyy년 M월 d일"
    
    case serverStyle = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
}


