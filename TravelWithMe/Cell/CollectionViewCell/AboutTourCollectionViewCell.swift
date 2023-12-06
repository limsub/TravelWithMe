//
//  AboutTourCollectionViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView
import Alamofire
import RxSwift
import RxCocoa

class AboutTourCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    // 이미지 뷰 얹고, 코너레디우스 주기. 굳이 패딩 안줘도 될듯
    let backImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.image = UIImage(named: "sample")
//        view.backgroundColor = .systemGray6
        
        view.isSkeletonable = true
        
        return view
    }()
    let shadowView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    let menuButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "dots")?.withTintColor(.white), for: .normal)
        return view
    }()
    
    let tourTitleLabel = ContentsTourTitleLabel(.white)
    
    let profileNameLabel = ContentsTourProfileNameLabel(.white)
    
    
    let lineView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let maxPeopleView = ContentsTourInfoView()
    let tourDatesView = ContentsTourInfoView()
    
    let profileImageView = ContentsProfileImageView(frame: .zero)
    
    
    override func setConfigure() {
        super.setConfigure()
        
        
        [backImageView, shadowView, maxPeopleView, tourDatesView, profileImageView, profileNameLabel, lineView, tourTitleLabel, menuButton].forEach { item  in
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
        
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(15)
            make.trailing.equalTo(contentView).inset(12)
            make.size.equalTo(25)
        }
        
        maxPeopleView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(15)
            make.leading.equalTo(contentView).inset(15)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        tourDatesView.snp.makeConstraints { make in
            make.leading.equalTo(maxPeopleView.snp.trailing).offset(16)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func designCell(_ sender: Datum) {
        
        
        // 1. 배경 이미지 (아직)
        if !sender.image.isEmpty {
            let imageEndString = sender.image[0]    // 맨 처음 이미지
            
            backImageView.loadImage(endURLString: imageEndString)
        } else {
            print("이미지 없으면 기본 이미지 띄워주기. 이거 만들어야 함")

        }
        
        // 2. 타이틀
        tourTitleLabel.text = sender.title
        
        // 3. 닉네임
        profileNameLabel.text = sender.creator.nick
        
            // 닉네임 길이에 따라 라인 길이 조절
        lineView.snp.makeConstraints { make in
            make.leading.equalTo(profileNameLabel.snp.trailing).offset(8)
        }
        
        // 4. 유저 프로필 이미지 (아직)
        profileImageView.image = UIImage(named: "sample")
        
        // 5. 최대 인원
        // JSON String -> Struct
        let cnt = Int(sender.maxPeopleCnt ?? "0") ?? 0
        maxPeopleView.setUp(.maxPeople(cnt: cnt))
        
        // 6. 날짜
        let dates = decodingStringToStruct(
            type: TourDates.self,
            sender: sender.dates
        )
        tourDatesView.setUp(.tourDates(dates: dates?.dates ?? []))
    }
    
    func disabledMenuButton() {
        menuButton.isEnabled = false
        menuButton.isHidden = true
    }
    
}
