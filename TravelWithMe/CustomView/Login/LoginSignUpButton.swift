//
//  LoginSignUpButton.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/13/23.
//

import UIKit

class LoginSignUpButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        setTitle("회원가입", for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
    }
}

