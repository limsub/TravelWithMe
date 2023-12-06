//
//  DetailTourBottomView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit

class DetailTourBottomView: BaseView {
    
//    let heartIconImageView = UIImageView()
    
    let commentIconImageView = UIImageView()
    
    let applyButton = DetailTourApplyButton()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [commentIconImageView, applyButton].forEach { item  in
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
//        heartIconImageView.snp.makeConstraints { make in
//            make.size.equalTo(24)
//            make.leading.top.equalTo(self).inset(27)
//            
//        }
        
        commentIconImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.top.equalTo(self).inset(27)
        }
        
        applyButton.snp.makeConstraints { make in
            make.trailing.equalTo(self).inset(27)
            make.leading.equalTo(commentIconImageView.snp.trailing).offset(27)
            make.centerY.equalTo(commentIconImageView)
            make.height.equalTo(48)
        }
    }
    
    override func setting() {
        super.setting()
                
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 20

        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -20)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
        
//        heartIconImageView.tintColor = UIColor.appColor(.main1)
        commentIconImageView.tintColor = UIColor.appColor(.main1)
        
//        heartIconImageView.image = UIImage(systemName: "heart")
        commentIconImageView.image = UIImage(systemName: "ellipsis.message")
        
    }
    
    
    
    
}


