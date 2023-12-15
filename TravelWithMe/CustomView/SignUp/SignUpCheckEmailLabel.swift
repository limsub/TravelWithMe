//
//  SignUpCheckEmailLabel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/21.
//

import UIKit

class SignUpCheckEmailLabel: UILabel {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        setUpText(.nothing)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        textColor = UIColor(hexCode: "938E8F")
        font = .systemFont(ofSize: 12)
        textAlignment = .right
    }
    
    func setUpText(_ type: ValidEmail) {
        self.text = type.description
        
        self.textColor = (type == .available) ? UIColor.appColor(.success) : UIColor.appColor(.main1)
        
    }
    
}
