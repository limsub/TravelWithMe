//
//  ProfileInfoFollowerCollectionViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit

// 셀 크기 80 x 100
class ProfileInfoFollowCollectionViewCell: BaseCollectionViewCell {
    
    let profileImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 34
        view.image = UIImage(named: "sample")
        return view
    }()
    
    let profileNameLabel = {
        let view = UILabel()
        view.text = "임승섭"
        view.font = .systemFont(ofSize: 12)
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [profileImageView, profileNameLabel].forEach { item in
            contentView.addSubview(item)
        }
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView)
            make.size.equalTo(68)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView)
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
        }
        
    }
    
    func designCell(_ sender: Creator) {
        
        // imageView
        if let imageUrl = sender.profile {
            profileImageView.loadImage(endURLString: imageUrl)
        } else {
            print("-- 셀 디자인. 저장된 profile image 링크가 없기 때문에 기본 이미지 세팅")
            profileImageView.image = UIImage(named: "sample")
        }
        
        // name
        if let nickStruct = decodingStringToStruct(type: ProfileInfo.self, sender: sender.nick) {
            profileNameLabel.text = nickStruct.nick
        }
        
    }
}
