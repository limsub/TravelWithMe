//
//  MakeTourTextView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit

class MakeTourTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        clipsToBounds = true
        layer.cornerRadius = 10
        backgroundColor = UIColor(hexCode: ConstantColor.textFieldBackground.hexCode)
        
        textColor = .black
    }
}
