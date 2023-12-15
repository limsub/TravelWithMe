//
//  SplashView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/13/23.
//

import UIKit

class SplashView: BaseView {
    
    let iconView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo_login")
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(iconView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(160)
            make.center.equalTo(self)
        }
    }
    
    override func setting() {
        super.setting()
        
        backgroundColor = .white
    }
}
