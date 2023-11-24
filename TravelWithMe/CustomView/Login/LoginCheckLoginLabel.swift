//
//  LoginCheckLoginLabel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/24.
//

import UIKit

// 로그인 실패 시 아래 보여줄 레이블
class LoginCheckLoginLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        text = ""   // 처음엔 아무것도 안보여준다
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpView() {
        textColor = UIColor(hexCode: ConstantColor.invalid.hexCode)
        font = .systemFont(ofSize: 14)
        textAlignment = .right
    }
    
    func setUpText(_ type: LoginAPIError) {
        text = type.description
        
    }
    
    
}
