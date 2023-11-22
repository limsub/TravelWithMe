//
//  Gender.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/22.
//

import Foundation

enum Gender: Int {
    
    case nothing = -1
    case female = 0
    case male = 1
    
    
    var description: String {
        switch self {
        case .nothing:
            return ""
        case .female:
            return "female"
        case .male:
            return "male"
        }
    }
}
