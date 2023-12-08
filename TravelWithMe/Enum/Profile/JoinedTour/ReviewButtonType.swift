//
//  ReviewButtonType.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/8/23.
//

import UIKit

enum ReviewButtonType {
    case beforeTravel
    case duringTravel
    case writeReview
    case checkReview
    
    
    var buttonTitle: String {
        switch self {
        case .beforeTravel:
            return "여행 전"
        case .duringTravel:
            return "여행 중"
        case .writeReview:
            return "후기 작성"
        case .checkReview:
            return "후기 확인"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .beforeTravel:
            return .lightGray
        case .duringTravel, .writeReview:
            return .white
        case .checkReview:
            return UIColor.appColor(.second1)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .beforeTravel:
            return .white
        case .duringTravel:
            return UIColor.appColor(.main1)
        case .writeReview:
            return UIColor.appColor(.second1)
        case .checkReview:
            return .white
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .beforeTravel, .duringTravel:
            return false
            
        case .writeReview, .checkReview:
            return true
        }
    }
}
