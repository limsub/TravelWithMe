//
//  TourCategoryType.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import Foundation

enum TourCategoryType: Int {
    
    case all
    case city
    case nature
    case culture
    case food
    case adventure
    case history
    case local
    
    var buttonTitle: String {
        switch self {
        case .all:
            return "  전체  "
        case .city:
            return "  도시  "
        case .nature:
            return "  자연  "
        case .culture:
            return "  문화  "
        case .food:
            return "  음식  "
        case .adventure:
            return "  모험  "
        case .history:
            return "  역사  "
        case .local:
            return "  로컬  "
        }
    }
    
    var hashTagText: String {
        switch self {
        case .all:
            return ""
        case .city:
            return "#도시 "
        case .nature:
            return "#자연 "
        case .culture:
            return "#문화 "
        case .food:
            return "#음식 "
        case .adventure:
            return "#모험 "
        case .history:
            return "#역사 "
        case .local:
            return "#로컬 "
        }
    }
    
}
