//
//  ValidPW.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/21.
//

import UIKit

enum ValidPW: Int {
    case nothing
    case tooShort
    case missingSpecialCharacter
    case available
    
    var description: String {
        switch self {
        case .nothing:
            return ""
        case .tooShort:
            return "8자 이상 입력해주세요"
        case .missingSpecialCharacter:
            return "특수문자와 숫자가 각각 1개 이상 포함되도록 입력해주세요"
        case .available:
            return "사용 가능한 비밀번호입니다"
        }
    }
    
    var color: String {
        switch self {
        case .nothing:
            return "000000"
        case .tooShort, .missingSpecialCharacter:
            return "FF0000"
        case .available:
            return "00FF00"
        }
    }

}
