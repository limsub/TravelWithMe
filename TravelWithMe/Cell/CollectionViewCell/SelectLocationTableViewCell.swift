//
//  SelectLocationTableViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/8/23.
//

import UIKit

// 셀 크기 66. 타이틀 폰트 14. 섭타이틀 폰트 12
class SelectLocationTableViewCell: BaseTableViewCell {
    
    let pinImageView = {
        let view = UIImageView()
        view.backgroundColor = .red
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        view.text = "hihi"
        return view
    }()
    
    let subTitleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.text = "HIhihihi"
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [pinImageView, titleLabel, subTitleLabel].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        
        pinImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(8)
            make.centerY.equalTo(contentView)
            make.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(15)
            make.leading.equalTo(pinImageView.snp.trailing).offset(10)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(15)
            make.leading.equalTo(pinImageView.snp.trailing).offset(10)
        }
    }
    
}

