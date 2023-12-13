//
//  SplashView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/13/23.
//

import UIKit

class SplashView: BaseView {
    
    let iconView = UIView()
    
    let nextButton = UIButton()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(iconView)
        addSubview(nextButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalTo(self)
        }
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalTo(self)
            make.top.equalTo(iconView.snp.bottom).offset(50)
        }
    }
    
    override func setting() {
        super.setting()
        
        backgroundColor = .white
        iconView.backgroundColor = .blue
        nextButton.backgroundColor = .yellow
    }
}
