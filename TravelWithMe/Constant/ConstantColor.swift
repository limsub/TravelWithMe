//
//  ConstantColor.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit



enum ColorSet: String {
    case main1 = "F63C6E"
    case main2 = "FCBBCC"
    case main3 = "FEE2E9"
    case main4 = "FEEBF0"
    case main5 = "FFF5F8"
    
    case second1 = "FF9E85"
    
    case black1 = "202020"
    case black2 = "1F1F1F"
    
    case gray1 = "938E8F"   // middle
    
    case disabledGray1 = "D0CCCD" // (light) disabled button text
    case disabledGray2 = "F1EEF0" // (light light) disabled button background
    
    case inputGray = "FBF8F9"  // textfield background
    
    case white1 = "FFFFFF"
    
    case success = "6BD495"
}


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
    
    
    case main1
    case main2
    case main3
    case main4
    case main5
    case main6
    case main7
    case main8
    
    
    var hexCode: String {
        switch self {
        case .textFieldBackground:
            return "FBF8F9"
        case .textFieldPlaceholder, .disabledButtonText:
            return "D0CCCD"
        case .Main1, .enabledButtonBackground:
            return "00FF00"
        case .Main2:
            return "007700"
            
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
            
            
        case .main1:
            return "#FFD8B1" // 페이드 코랄 (Faded Coral)
        case .main2:
            return "#FFBFA3" // 코랄 피치 (Coral Peach)
        case .main3:
            return "#FFD699" // 선명한 오렌지 (Vivid Orange)
        case .main4:
            return "#FFCC99" // 주황 갈색 (Orange Tan)
        case .main5:
            return "#FFEBCC" // 금빛 주황 (Golden Orange)
        case .main6:
            return "#FFD9B3" // 연한 주황 회색 (Light Orange Grreturn ay)
        case .main7:
            return "#FFA366" // 밝은 썬셋 (Bright Sunset)
        case .main8:
            return "#FFD1A0" // 페이드 오렌지 (Faded Orange)
            
            
            
            
            
        default:
            return "000000"
        }
        
    }
}
