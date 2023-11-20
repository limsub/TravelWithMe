//
//  SignUpGenderSegmentControl.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit

class SignUpGenderSegmentControl: UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(items: items)
            
        setUp()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        
//        selectedSegmentTintColor = UIColor(hexCode: ConstantColor.Main1.rawValue)
        
//        backgroundColor = UIColor(hexCode: ConstantColor.Main2.rawValue).withAlphaComponent(0.5)
        
        clipsToBounds = true
        layer.cornerRadius = 10
        
    }
}
