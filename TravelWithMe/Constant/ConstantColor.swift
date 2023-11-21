//
//  ConstantColor.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit



enum ConstantColor {
    case textFieldBackground
    case textFieldPlaceholder
    
    case Main1
    case Main2
    
    case disabledButtonBackground
    case disabledButtonText
    
    case enabledButtonBackground
    case enabledButtonText
    
    case baseLabelText
    
    case invalid
    case valid
    
    var hexCode: String {
        switch self {
        case .textFieldBackground:
            return "FBF8F9"
        case .textFieldPlaceholder, .disabledButtonText:
            return "D0CCCD"
        case .Main1, .enabledButtonBackground:
            return "F63C6E"
        case .Main2:
            return "FEE2E9"
        case .disabledButtonBackground:
            return "F1EEF0"
        case .enabledButtonText:
            return "FFFFFF"
        case .baseLabelText:
            return "938E8F"
        case .invalid:
            return "FF0000"
        case .valid:
            return "00FF00"
        default:
            return "000000"
        }
        
    }
}
