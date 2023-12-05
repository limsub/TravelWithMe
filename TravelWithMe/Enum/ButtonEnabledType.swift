//
//  ButtonEnabledType.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/5/23.
//

import UIKit

enum ButtonEnabledType {
    case enabled
    case disabled
    
    var textColor: UIColor {
        switch self {
        case .enabled:
            return .white
        case .disabled:
            return UIColor.appColor(.disabledGray1)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .enabled:
            return UIColor.appColor(.main1)
        case .disabled:
            return UIColor.appColor(.disabledGray2)
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .enabled:
            return true
        case .disabled:
            return false
        }
    }
}
