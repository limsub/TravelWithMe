//
//  SignUpSmallButton.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit

class SignUpCheckEmailButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    convenience init(_ title: String) {
        self.init()
        
        setTitle(title, for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        update(.disabled)
        
        titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    func update(_ state: ButtonEnabledType) {
        self.isEnabled = state.isEnabled
        
        if state == .enabled {
            backgroundColor = UIColor.appColor(.main3)
            setTitleColor(UIColor.appColor(.main1), for: .normal)
        } else {
            backgroundColor = state.backgroundColor
            setTitleColor(state.textColor, for: .normal)
        }   
    }
}
