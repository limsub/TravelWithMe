//
//  SignUpCompleteButton.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit

class SignUpCompleteButton: UIButton {
    
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
        update(.disabled) // 기본적으로 enable false
        
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    func update(_ state: ButtonEnabledType) {
        self.isEnabled = state.isEnabled
        backgroundColor = state.backgroundColor
        setTitleColor(state.textColor, for: .normal)
    }
}


