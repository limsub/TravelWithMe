//
//  TourTypeInfo.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import Foundation

enum TourInfoType {
    case maxPeople(cnt: Int)
    case tourDates(dates: [String])
    
    var imageName: String {
        switch self {
        case .maxPeople:
            return "person"
        case .tourDates:
            return "calendar"
        }
    }
    
    var infoLabelText: String {
        switch self {
        case .maxPeople(let cnt):
            return "최대 \(cnt)명"
        case .tourDates(let dates):
            // 말도 안되지만, 배열이 비었을 때 예외처리 (index OutofBounds 대비)
            if dates.isEmpty { return "" }
            
            // case 1. 단일 여행
            if dates.count == 1 {
                return dates[0].toDate(to: .full)!.toString(of: .monthSlashDay)
            }
            
            // case 2. 기간 여행
            else {
                let firstDate = dates[0].toDate(to: .full)!.toString(of: .monthSlashDay)
                let lastDate = dates[1].toDate(to: .full)!.toString(of: .monthSlashDay)
                
                return "\(firstDate) ~ \(lastDate)"
            }
        }
    }
    
    var typeName: String {
        switch self {
        case .maxPeople:
            return "여행 인원"
        case .tourDates:
            return "여행 일자"
        }
    }
}
