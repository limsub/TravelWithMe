//
//  ContentsTourInfoView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit
import SnapKit


class ContentsTourInfoView: BaseView {
    
    func setUp(_ info: TourInfoType) {
        imageView.image = UIImage(systemName: info.imageName)
        infoLabel.text = info.infoLabelText
    }
    
    let imageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person")
        view.tintColor = UIColor.appColor(.second1)
        return view
    }()
    
    let infoLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.text = "최대 3명"
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
//        self.backgroundColor = .purple
        
        [imageView, infoLabel].forEach { item  in
            addSubview(item)
        }
    }
    
    // 뷰 height 20으로 고정
    override func setConstraints() {
        super.setConstraints()
        
        imageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self)
            make.width.equalTo(imageView.snp.height)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self)
        }
    }
}
