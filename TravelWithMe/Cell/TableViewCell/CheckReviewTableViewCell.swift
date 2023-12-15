//
//  CheckReviewTableViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/10/23.
//

import UIKit
import SnapKit




class CheckReviewTableViewCell: BaseTableViewCell {
    
    let backViewNotMe = ReviewNotMeBackView()
    let backViewForMe = ReviewForMeBackView()
    
    let profileImageView = ContentsProfileImageView(frame: .zero)
    let profileNameLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .black
        view.text = "임승섭입니다"
        return view
    }()
    
    let seperateLineView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    // 리뷰 카테고리 개수가 정해져있지 않기 때문에 (1 ~ 3) 컬렉션뷰로 구성한다
//    lazy var reviewCategoryCollectionView = {
//        let view = UICollectionView(frame: .zero, collectionViewLayout: createCheckReviewCategoryCollectionViewLayout())
////        let view = UIView()
//        return view
//    }()
    
    static func makeReviewCategoryLabel() -> UILabel {
        let view = UILabel()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.appColor(.main1).cgColor
//        view.textColor = UIColor.appColor(.main1)
        view.textColor = UIColor.appColor(.gray1)
        
        view.font = .systemFont(ofSize: 12)
//        view.text = "로컬"
        view.text = ReviewCategoryType.regretful.buttonTitle
        view.backgroundColor = .white.withAlphaComponent(0.7)
        
        return view
    }
    let categoryLabel1 = makeReviewCategoryLabel()
    let categoryLabel2 = makeReviewCategoryLabel()
    let categoryLabel3 = makeReviewCategoryLabel()
    
    
    
    let reviewContentsLabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 14)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .left
        
        view.text = ["안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일", "aaaaaaaaaaaaaaaaaaaaaaaaa", "bbbb", "cccc\nccccc\nccccccccccccccccccccccccc\nccc\nccccc\ncccccccccccc\ncccccccc\ncccccccccc\ncccccc", "d"].randomElement()!
        
        return view
    }()
    
    let reviewDateLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = UIColor.appColor(.gray1)
        view.textAlignment = .left
        view.numberOfLines = 1
        
        view.text = "2023.10.23"
        return view
    }()
    
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [backViewForMe, backViewNotMe].forEach { item in
            contentView.addSubview(item)
            item.backgroundColor = .white
        }
        
        [profileImageView, profileNameLabel, seperateLineView, categoryLabel1, categoryLabel2, categoryLabel3, reviewContentsLabel, reviewDateLabel].forEach { item in
            contentView.addSubview(item)
//            item.backgroundColor = .red
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let padding = 18 + 12
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(contentView).inset(15)
            make.leading.equalTo(contentView).inset(padding)
        }
        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(profileImageView)
        }
        
        seperateLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(padding)
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.height.equalTo(1)
        }
        
//        reviewCategoryCollectionView.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(contentView).inset(padding)
//            make.top.equalTo(seperateLineView.snp.bottom).offset(8)
//            make.height.equalTo(30)
//        }
        
        categoryLabel1.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(padding)
            make.top.equalTo(seperateLineView.snp.bottom).offset(8)
            make.height.equalTo(30)
        }
        categoryLabel2.snp.makeConstraints { make in
            make.leading.equalTo(categoryLabel1.snp.trailing).offset(10)
            make.top.height.equalTo(categoryLabel1)
        }
        categoryLabel3.snp.makeConstraints { make in
            make.leading.equalTo(categoryLabel2.snp.trailing).offset(10)
            make.top.height.equalTo(categoryLabel1)
        }
        
        
        reviewContentsLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(padding)
            make.top.equalTo(categoryLabel1.snp.bottom).offset(8)
        }
        reviewDateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(padding)
            make.top.equalTo(reviewContentsLabel.snp.bottom).offset(8)
//            make.bottom.equalTo(contentView).inset(15)
        }
        
        backViewNotMe.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.top.equalTo(profileImageView.snp.top).offset(-12)
            make.bottom.equalTo(reviewDateLabel.snp.bottom).offset(20)
            make.bottom.equalTo(contentView).inset(10)
        }
        backViewForMe.snp.makeConstraints { make in
            make.edges.equalTo(backViewNotMe)
        }
        backViewNotMe.isHidden = true
        
    }
    
    
    override func setting() {
        super.setting()
        
        
    }
    
    func designCell(_ sender: Comment) {
        
        // profileImageView
        if let imageEndString = sender.creator.profile {
            let size = profileImageView.bounds.size
            print("-- CheckReview -- downsampling size : \(size)")
            profileImageView.loadImage(endURLString: imageEndString, size: size)
        } else {
            print("이미지 없으면 기본 이미지 띄워주기. 이거 만들어야 함 - 3")
        }
        
        // profileName
        if let nickStruct = decodingStringToStruct(type: ProfileInfo.self, sender: sender.creator.nick) {
            profileNameLabel.text = nickStruct.nick
        }
        
        // content
        if let contentStruct = decodingStringToStruct(type: ReviewContent.self, sender: sender.content) {
            reviewContentsLabel.text = contentStruct.content
            
            let typeCnt = contentStruct.categoryArr.count
            let arr = contentStruct.categoryArr
            switch typeCnt {
            case 1:
                categoryLabel1.isHidden = false
                categoryLabel2.isHidden = true
                categoryLabel3.isHidden = true
                
                categoryLabel1.text = ReviewCategoryType(rawValue: arr[0])?.buttonTitle
            case 2:
                categoryLabel1.isHidden = false
                categoryLabel2.isHidden = false
                categoryLabel3.isHidden = true
                
                categoryLabel1.text = ReviewCategoryType(rawValue: arr[0])?.buttonTitle
                categoryLabel2.text = ReviewCategoryType(rawValue: arr[1])?.buttonTitle
            case 3:
                categoryLabel1.isHidden = false
                categoryLabel2.isHidden = false
                categoryLabel3.isHidden = false
                
                categoryLabel1.text = ReviewCategoryType(rawValue: arr[0])?.buttonTitle
                categoryLabel2.text = ReviewCategoryType(rawValue: arr[1])?.buttonTitle
                categoryLabel3.text = ReviewCategoryType(rawValue: arr[2])?.buttonTitle
            default:
                categoryLabel1.isHidden = true
                categoryLabel2.isHidden = true
                categoryLabel3.isHidden = true
                
            }
        }
        
        // date
        reviewDateLabel.text = sender.time.toDate(to: .serverStyle)?.toString(of: .fullWithDot)
        
        
        // select backView
        if sender.creator._id == KeychainStorage.shared._id {
            backViewForMe.isHidden = false
            backViewNotMe.isHidden = true
        } else {
            backViewForMe.isHidden = true
            backViewNotMe.isHidden = false
        }
        
        
        
    }
    
    
}
