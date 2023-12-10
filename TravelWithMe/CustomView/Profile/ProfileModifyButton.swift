//
//  ProfileModifyButton.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/29.
//

import UIKit

enum ProfileButtonType {
    case modify
    case follow
    case unfollow
    
    var buttonTitle: String {
        switch self {
        case .modify:
            return "수정하기"
        case .follow:
            return "팔로우"
        case .unfollow:
            return "언팔로우"
            
        }
    }
}

class ProfileModifyButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp() {
        
        setTitle("수정하기", for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        
        clipsToBounds = true
        layer.cornerRadius = 16
        
        backgroundColor = UIColor.appColor(.main4)
        setTitleColor(UIColor.appColor(.main1), for: .normal)

    }
    
    func updateButton(_ userType: UserType) {
        
        setTitle(userType.profileButtonType.buttonTitle, for: .normal)
    }
    
}
