//
//  DetailTourCategoryCollectionViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit

class DetailTourCategoryCollectionViewCell: BaseCollectionViewCell {
    
    let mainLabel = {
        let view = UILabel()
        
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.appColor(.main1).cgColor
        
        view.text = "로컬"
        view.textColor = UIColor.appColor(.main1)
        
        view.font = .systemFont(ofSize: 12)
        
        
        view.textAlignment = .center
        
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(mainLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        mainLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
