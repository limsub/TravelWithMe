//
//  ApplyButtonType.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/7/23.
//

import UIKit

enum ApplyButtonType {
    case myTour(likes: Int, max: Int)
    
    
    case outOfDate(likes: Int, max: Int)
    
    case unApplied(likes: Int, max: Int)
    case closed(max: Int)
    
    case applied(likes: Int, max: Int)  // 신청한 투어라면 마감되었더라도 취소할 수 있게 함.
    // 조건문 돌 때 무조건 내가 신청했는지부터 확인하기!!
    
    var buttonTitle: String {
        switch self {
        case .myTour(let likes, let max):
            return "신청 현황 \(likes) / \(max)"
        case .outOfDate(let likes, let max):
            return "기한 마감 \(likes) / \(max)"
        case .unApplied(let likes, let max):
            return "신청하기 \(likes) / \(max)"
        case .closed(let max):
            return "마감 \(max) / \(max)"
            
        case .applied(let likes, let max):
            return "취소하기 \(likes) / \(max)"
        
        }
    }
    
    var buttonEnabled: ButtonEnabledType {
        switch self {
        case .myTour:
            return .enabled
        case .outOfDate:
            return .disabled
        case .unApplied:
            return .enabled
        case .closed:
            return .disabled
        case .applied:
            return .enabled
        }
    }
    
    
}
