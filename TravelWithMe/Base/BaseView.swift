//
//  BaseView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setConstraints()
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfigure() { }
    func setConstraints() { }
    func setting() { }
}
