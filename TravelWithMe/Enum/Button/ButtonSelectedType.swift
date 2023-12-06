//
//  ButtonSelectedType.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/6/23.
//

import UIKit

enum ButtonSelectedType {
    case selected
    case normal
    
    var textColor: UIColor {
        switch self {
        case .selected:
            return UIColor.appColor(.main1)
        case .normal:
            return UIColor.black
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .selected:
            return UIColor.appColor(.main1)
        case .normal:
            return UIColor.appColor(.main3)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .selected:
            return UIColor.appColor(.main3)
        case .normal:
            return UIColor.appColor(.main5)
        }
    }
}
