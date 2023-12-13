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
        titleLabel?.font = .boldSystemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
//        backgroundColor = UIColor(hexCode: ConstantColor.Main2.hexCode)
//        setTitleColor(UIColor(hexCode: ConstantColor.Main1.hexCode), for: .normal)
        
        backgroundColor = .lightGray
        setTitleColor(.darkGray, for: .normal)
        
        clipsToBounds = true
        layer.cornerRadius = 10
    }
}
