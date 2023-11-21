//
//  ValidEmail.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/21.
//

import Foundation

enum ValidEmail: Int {
    case nothing
    case invalidFormat
    case validFormatBeforeCheck
    case alreadyInUse
    case available
    
    var description: String {
        switch self {
        case .nothing:
            return ""
        case .invalidFormat:
            return "이메일 형식에 맞지 않습니다"
        case .validFormatBeforeCheck:
            return "이메일 중복 확인을 해주세요"
        case .alreadyInUse:
            return "이미 사용중인 이메일입니다"
        case .available:
            return "사용 가능한 이메일입니다"
        }
    }
    
    var color: String {
        switch self {
        case .nothing:
            return "000000"
        case .invalidFormat, .alreadyInUse, .validFormatBeforeCheck:
            return "FF0000"
        case .available:
            return "00FF00"
        }
    }
}
