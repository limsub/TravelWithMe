//
//  AboutTourCollectionViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit


class AboutTourCollectionViewCell: BaseCollectionViewCell {
    
    // 이미지 뷰 얹고, 코너레디우스 주기. 굳이 패딩 안줘도 될듯
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.backgroundColor = .red
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        
    }
    
    
}
