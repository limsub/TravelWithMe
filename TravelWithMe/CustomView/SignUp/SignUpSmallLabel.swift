//
//  SignUpSmallLabel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit

class SignUpSmallLabel: UILabel {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    convenience init(_ text: String, color: String = ConstantColor.baseLabelText.hexCode) {
        self.init()
        
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        textColor = UIColor(hexCode: "938E8F")
        font = .systemFont(ofSize: 14)
        textAlignment = .left
    }
}
