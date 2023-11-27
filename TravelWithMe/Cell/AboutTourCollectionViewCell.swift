//
//  AboutTourCollectionViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit
import SnapKit



class AboutTourCollectionViewCell: BaseCollectionViewCell {
    
    // 이미지 뷰 얹고, 코너레디우스 주기. 굳이 패딩 안줘도 될듯
    let backImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.image = UIImage(named: "sample")
//        view.backgroundColor = .systemGray6
        return view
    }()
    let shadowView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    let tourTitleLabel = {
        let view = UILabel()
        
//        view.backgroundColor = .purple
        view.font = .boldSystemFont(ofSize: 20)
        view.textColor = .white
        view.text = "3박 4일 도쿄 여행 같이 가실분sadjfl;kjasd;lfkjas;dlfkja;slkdfja;sldkjf"
        view.numberOfLines = 2
        return view
    }()
    
    let profileNameLabel = {
        let view = UILabel()
//        view.backgroundColor = .purple
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.text = "임승섭입니다"
        
        return view
    }()
    
    let lineView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let maxPeopleView = ContentsTourInfoView()
    let tourDatesView = ContentsTourInfoView()
    
    let profileImageView = ContentsProfileImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    
    override func setConfigure() {
        super.setConfigure()
        
        
        [backImageView, shadowView, maxPeopleView, tourDatesView, profileImageView, profileNameLabel, lineView, tourTitleLabel].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        backImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(backImageView)
        }
        
        maxPeopleView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(15)
            make.leading.equalTo(contentView).inset(15)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        
        tourDatesView.snp.makeConstraints { make in
            make.leading.equalTo(maxPeopleView.snp.trailing).offset(20)
            make.height.equalTo(30)
            make.bottom.equalTo(contentView).inset(15)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(15)
            make.trailing.equalTo(contentView).inset(15)
            make.size.equalTo(54)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(maxPeopleView.snp.top).offset(-12)
            make.leading.equalTo(maxPeopleView)
        }
        
        lineView.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.leading).inset(2)
            make.leading.equalTo(profileNameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(profileNameLabel)
            make.height.equalTo(1)
        }
        
        tourTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileNameLabel.snp.top).offset(-12)
            make.leading.equalTo(maxPeopleView)
            make.trailing.equalTo(profileImageView)
        }
    }
    
    
    func designCell() {
        
        maxPeopleView.setUp(TourInfoType.maxPeople(cnt: 3))
        tourDatesView.setUp(TourInfoType.tourDates(dates: ["20230111", "20230912"]))
        
        profileImageView.image = UIImage(named: "sample")
        
        profileNameLabel.text = "임승섭asdfjlak;sjdfl;sakdjf"
        lineView.snp.makeConstraints { make in
            make.leading.equalTo(profileNameLabel.snp.trailing).offset(8)
        }
    }
    
}
