//
//  ValidNickname.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/21.
//

import Foundation

enum ValidNickname: Int {
    case nothing
    case invalidLength
    case available
    
    var description: String {
        switch self {
        case .nothing:
            return ""
        case .invalidLength:
            return "2자 이상 6자 이하로 입력해주세요"
        case .available:
            return "사용 가능한 닉네임입니다"
        }
    }
    
    var color: String {
        switch self {
        case .nothing:
            return "000000"
        case .invalidLength:
            return ConstantColor.invalid.hexCode
        case .available:
            return ConstantColor.valid.hexCode
        }
    }
}
