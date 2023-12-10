//
//  UserType.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/10/23.
//

import Foundation

enum UserType: Equatable {
    case me
    case other(userId: String, isFollowing: Bool)
    
    var profileButtonType: ProfileButtonType {
        switch self {
        case .me:
            return .modify
        case .other(_, let isFollowing):
            return isFollowing ? .unfollow : .follow
        }
    }
}
