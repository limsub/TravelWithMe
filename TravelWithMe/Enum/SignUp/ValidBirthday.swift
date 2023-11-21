//
//  ValidBirthday.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/21.
//

import Foundation

enum ValidBirthday: Int {
    case nothing
    case invalidFormat
    case available
    
    var description: String {
        switch self {
        case .nothing:
            return ""
        case .invalidFormat:
            return "생년월일 형식에 맞지 않습니다 (YYYYMMDD)"
        case .available:
            return ""
        }
    }
    
    var color: String {
        switch self {
        case .nothing, .available:
            return "000000"
        case .invalidFormat:
            return ConstantColor.invalid.hexCode
        }
    
    }
}
