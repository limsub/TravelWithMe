//
//  ProfileView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/29.
//

import UIKit

class ProfileView: BaseView {
    
    let topView = ProfileTopView()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(topView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        topView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(220)
        }
    }
    
    override func setting() {
        super.setting()
        
    }
    
    
    
}
