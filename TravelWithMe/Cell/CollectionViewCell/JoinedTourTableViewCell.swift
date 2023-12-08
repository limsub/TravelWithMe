//
//  JoinedTourTableViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/8/23.
//

import UIKit

class JoinedTourTableViewCell: BaseTableViewCell {
    
    let dateLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.text = "12th"
        return view
    }()
    
    // 샘플 사이즈 = 10
    let dotView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    let topLineView = {
        let view = UIView()
        return view
    }()
    let bottomLineView = {
        let view = UIView()
        return view
    }()
    
    let backImageView = {
        let view = UIImageView()
        return view
    }()
    let imageButton = {
        let view = UIButton()
        return view
    }()
    
    let tourTitleLabel = {
        let view = UILabel()
        view.text = "투어 제목"
        return view
    }()
    let tourMakerLabel = {
        let view = UILabel()
        view.text = "투어 제작자"
        return view
    }()
    let reviewButton = {
        let view = UIButton()
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [dateLabel, dotView, topLineView, bottomLineView, backImageView, imageButton, tourTitleLabel, tourMakerLabel, reviewButton].forEach { item in
            contentView.addSubview(item)
            item.backgroundColor = [.red, .blue, .black, .purple].randomElement()!
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(18)
            make.top.equalTo(contentView).inset(26)
            make.width.equalTo(30)
        }
        dotView.snp.makeConstraints { make in
            make.size.equalTo(10)
            make.leading.equalTo(dateLabel.snp.trailing).offset(17)
            make.centerY.equalTo(dateLabel)
        }
        topLineView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.centerX.equalTo(dotView)
            make.bottom.equalTo(dotView.snp.centerY)
            make.width.equalTo(1)
        }
        bottomLineView.snp.makeConstraints { make in
            make.top.equalTo(dotView.snp.centerY)
            make.centerX.equalTo(dotView)
            make.bottom.equalTo(contentView)
            make.width.equalTo(1)
        }
        
        backImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(dotView.snp.centerX).offset(14)
            make.height.equalTo(130)    // 셀 높이 140으로 맞출 예정
            make.trailing.equalTo(contentView).inset(18)
        }
        imageButton.snp.makeConstraints { make in
            make.edges.equalTo(backImageView)
        }
        
        tourTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(backImageView).inset(20)
        }
        tourMakerLabel.snp.makeConstraints { make in
            make.top.equalTo(tourTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(tourTitleLabel)
        }
        
        reviewButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.trailing.bottom.equalTo(backImageView).inset(20)
        }
    }
    
    override func setting() {
        super.setting()
        
        
    }
}
