//
//  ProfileInfoView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit
import SnapKit

class ProfileInfoView: BaseView {
    
    let spacerView = UIView()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let introduceNameLabel  = SignUpSmallLabel("소개")
    let genderNameLabel = SignUpSmallLabel("성별")
    let birthdayNameLabel = SignUpSmallLabel("생년월일")
    
    let followerNameLabel = SignUpSmallLabel("팔로워")
    let followingNameLabel = SignUpSmallLabel("팔로잉")
    
    
    
    let introduceContentLabel = ProfileInfoContentLabel(
    """
    안녕하세요! 여행의 마법을 전하는 여행 가이드, [이름]입니다. 제 여행은 단순한 관광이 아니라 각 도시와 문화의 숨겨진 이야기, 지혜, 그리고 아름다움을 찾아 나서는 것을 목표로 하고 있습니다.

    여행이라는 새로운 세계에서 여러분을 안내할 기회를 갖게 되어 기쁘게 생각하고 있습니다. 함께 멋진 여행을 만들어 나가요! 여행의 향기가 여러분에게 기쁨과 전율을 안겨줄 것입니다.
    """
    )
    let genderContentLabel = ProfileInfoContentLabel("여성")
    let birthdayContentLabel = ProfileInfoContentLabel("1999년 8월 20일")
    
    lazy var followerCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createFollowerCollectionViewLayout())
        view.register(ProfileInfoFollowCollectionViewCell.self, forCellWithReuseIdentifier: Identifier.profileInfoFollowerCollectionView.rawValue)
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    lazy var followingCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createFollowerCollectionViewLayout())
        view.register(ProfileInfoFollowCollectionViewCell.self, forCellWithReuseIdentifier: Identifier.profileInfoFollowingCollectionView.rawValue)
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(spacerView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [introduceNameLabel, genderNameLabel, birthdayNameLabel, followerNameLabel, followingNameLabel,  introduceContentLabel, genderContentLabel, birthdayContentLabel, followerCollectionView, followingCollectionView].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        spacerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self)
            make.height.equalTo(270)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(spacerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            // (self.snp.height -> scrollView.snp.height) 변경
            make.height.greaterThanOrEqualTo(scrollView.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        

        
        introduceNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(30)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        introduceContentLabel.snp.makeConstraints { make in
            make.top.equalTo(introduceNameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        
        genderNameLabel.snp.makeConstraints { make in
            make.top.equalTo(introduceContentLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        genderContentLabel.snp.makeConstraints { make in
            make.top.equalTo(genderNameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        
        birthdayNameLabel.snp.makeConstraints { make in
            make.top.equalTo(genderContentLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        birthdayContentLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayNameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(18)
//            make.bottom.equalTo(contentView).inset(20)
        }
        
        followerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayContentLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        followerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(followerNameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        followingNameLabel.snp.makeConstraints { make in
            make.top.equalTo(followerCollectionView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        followingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(followingNameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(100)
            make.bottom.equalTo(contentView).inset(20)
        }
    }
    
    override func setting() {
        super.setting()
        
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func updateView(_ sender: LookProfileResponse) {

        if let infoStruct = decodingStringToStruct(type: ProfileInfo.self, sender: sender.nick) {
            
            introduceContentLabel.text = infoStruct.introduce
            
            genderContentLabel.text = GenderType(rawValue: infoStruct.gender)?.koreanDescription
            
            birthdayContentLabel.text = infoStruct.birthday.toDate(to: .full)?.toString(of: .koreanFullString)
        }
    }
}
