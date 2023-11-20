//
//  SignUpTextField.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit

class SignUpTextField: UITextField {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(_ placeholder: String) {
        self.init()
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(hexCode: ConstantColor.textFieldPlaceholder.hexCode), .font: UIFont.systemFont(ofSize: 14)])
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        clipsToBounds = true
        layer.cornerRadius = 10
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        leftViewMode = .always
        backgroundColor = UIColor(hexCode: ConstantColor.textFieldBackground.hexCode)
    
        
        textColor = .black
    }
    
    
}
