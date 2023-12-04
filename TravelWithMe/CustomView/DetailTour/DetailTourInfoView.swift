//
//  DetailTourInfoView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit
import SnapKit

class DetailTourInfoView: BaseView {
    
    func setUp(_ info: TourInfoType) {
        iconImageView.image = UIImage(systemName: info.imageName)
        
        // 일단 보류 - 투어 날짜 수정해야 함
        
    }
    
    
    let iconImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person")
        return view
    }()
    
    let infoNameLabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 12)
        view.textColor = UIColor(hexCode: ConstantColor.baseLabelText.hexCode)
        view.textAlignment = .center
        
        
        view.text = "투어 인원"
        
        return view
    }()
    
    let infoContentsLabel = {
        let view = UILabel()
        
        view.font = .boldSystemFont(ofSize: 18)
        view.textAlignment = .center
        
        view.text = "최대 2명"
        
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [iconImageView, infoNameLabel, infoContentsLabel].forEach { item  in
            addSubview(item)
        }
    }
    
    // 뷰 height 92 고정
    override func setConstraints() {
        super.setConstraints()
        
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            
            make.top.equalTo(self).inset(10)
            make.size.equalTo(20)
            
        }
        infoNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
        }
        infoContentsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            
            make.top.equalTo(infoNameLabel.snp.bottom).offset(8)
            
            make.bottom.equalTo(self).inset(15)
        }
    }
    
    override func setting() {
        super.setting()
        
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        
        self.layer.cornerRadius = 10        
    }
}
