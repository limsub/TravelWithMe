//
//  ModifyProfileView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/11/23.
//

import UIKit


class ModifyProfileView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    let profileImageLabel = SignUpSmallLabel("프로필 이미지")
    let nicknameLabel = SignUpSmallLabel("닉네임")
    let birthdayLabel = SignUpSmallLabel("생년월일")
    let genderLabel = SignUpSmallLabel("성별")
    let introduceLabel = SignUpSmallLabel("소개")
    
    
    let profileImageView = ModifyProfileImageView(frame: .zero)
    let smallCameraImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "camera.circle.fill")
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        view.tintColor = .black
        return view
    }()
    let nicknameTextField = SignUpTextField("닉네임을 입력해주세요")
    let birthdayTextField = SignUpTextField("YYYYMMDD")
    let genderSelectSegmentControl = SignUpGenderSegmentControl(items: ["여성", "남성"])
    let introduceTextView = MakeTourTextView()
    
    
    let checkNicknameLabel = SignUpCheckNicknameLabel()
    let checkBirthdayLabel = SignUpCheckBirthdayLabel()
    
    let completeButton = SignUpCompleteButton("완료")
    
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [profileImageLabel, nicknameLabel, birthdayLabel, genderLabel, introduceLabel, profileImageView, smallCameraImageView, nicknameTextField, birthdayTextField, genderSelectSegmentControl, introduceTextView, checkNicknameLabel, checkBirthdayLabel, completeButton].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        profileImageLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(40)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(120)
            make.top.equalTo(profileImageLabel.snp.bottom).offset(20)
            make.centerX.equalTo(contentView)
        }
        smallCameraImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.bottom.trailing.equalTo(profileImageView)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.height.equalTo(52)
        }
        checkNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            make.leading.equalTo(contentView).inset(24)
        }
        
        birthdayLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(40)
            make.leading.equalTo(contentView).inset(18)
        }
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel)
            make.leading.equalTo(contentView.snp.centerX).offset(8)
        }
        birthdayTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(18)
            make.top.equalTo(birthdayLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
            make.trailing.equalTo(contentView.snp.centerX)
        }
        genderSelectSegmentControl.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.centerX).offset(8)
            make.top.equalTo(birthdayTextField)
            make.height.equalTo(52)
            make.trailing.equalTo(contentView).inset(18)
        }
        checkBirthdayLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(24)
            make.top.equalTo(birthdayTextField.snp.bottom).offset(8)
        }
        
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayTextField.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        introduceTextView.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp.bottom).offset(8)
            make.height.equalTo(150)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.top.equalTo(introduceTextView.snp.bottom).offset(40)
            make.height.equalTo(52)
            make.bottom.equalTo(contentView).inset(40)
        }
        
        
    }
    
    override func setting() {
        super.setting()
        
        backgroundColor = .blue
    }
}
