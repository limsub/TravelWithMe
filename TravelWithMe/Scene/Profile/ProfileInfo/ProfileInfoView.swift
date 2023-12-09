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
    
    
    let followerNameLabel = SignUpSmallLabel("팔로워")
    let introduceNameLabel  = SignUpSmallLabel("소개")
    let genderNameLabel = SignUpSmallLabel("성별")
    let birthdayNameLabel = SignUpSmallLabel("생년월일")
    
    
    let followerCollectionView = {
//        let view = UICollectionView()
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    let introduceContentLabel = ProfileInfoContentLabel(
    """
    안녕하세요! 여행의 마법을 전하는 여행 가이드, [이름]입니다. 제 여행은 단순한 관광이 아니라 각 도시와 문화의 숨겨진 이야기, 지혜, 그리고 아름다움을 찾아 나서는 것을 목표로 하고 있습니다.

    [도시/지역]에서의 여행은 물론이고, 세계 각지에서 다채로운 경험을 쌓아왔습니다. 제가 안내하는 여행은 그 지역 특유의 역사, 예술, 그리고 현지 문화를 깊이 있게 이해하고 체험할 수 있는 특별한 기회를 제공합니다.

    매 여행은 여러분에게 더 깊이있는 연결과 기억을 선사하기 위해 정성을 다하고 있습니다. 특별한 순간들과 함께 지역의 맛, 향, 소리를 즐기며, 새로운 친구들과 소중한 추억을 만들어보세요.

    제 여행은 언제나 유쾌하고 안전하며, 여행하는 동안 여러분이 가장 편안하게 느끼실 수 있도록 최선을 다하고 있습니다. 함께 여행하는 동안 여행지의 숨은 보물들을 함께 찾아 나서며, 여행을 통해 세상을 더 깊이 이해하고, 다양성을 존중하는 여정이 되길 희망합니다.

    여행이라는 새로운 세계에서 여러분을 안내할 기회를 갖게 되어 기쁘게 생각하고 있습니다. 함께 멋진 여행을 만들어 나가요! 여행의 향기가 여러분에게 기쁨과 전율을 안겨줄 것입니다.
    """
    )
    let genderContentLabel = ProfileInfoContentLabel("여성")
    let birthdayContentLabel = ProfileInfoContentLabel("1999년 8월 20일")
                                                        
    
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(spacerView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [followerNameLabel, introduceNameLabel, genderNameLabel, birthdayNameLabel, followerCollectionView, introduceContentLabel, genderContentLabel, birthdayContentLabel].forEach { item in
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
        
        followerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(35)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        followerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(followerNameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        introduceNameLabel.snp.makeConstraints { make in
            make.top.equalTo(followerCollectionView.snp.bottom).offset(30)
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
            make.bottom.equalTo(contentView).inset(20)
        }
    }
    
    
}
