//
//  SignUpView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit
import SnapKit

class SignUpView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let emailLabel = SignUpSmallLabel("이메일 계정")
    let pwLabel = SignUpSmallLabel("비밀번호")
    let nicknameLabel = SignUpSmallLabel("닉네임")
    let birthdayLabel = SignUpSmallLabel("생년월일")
    let genderLabel = SignUpSmallLabel("성별")
    let introduceLabel = SignUpSmallLabel("소개")
    
    let emailTextField = SignUpTextField("이메일을 입력해주세요")
    let pwTextField = SignUpTextField("비밀번호를 입력해주세요")
    let nicknameTextField = SignUpTextField("닉네임을 입력해주세요")
    let birthdayTextField = SignUpTextField("YYYYMMDD")
    let introduceTextView = MakeTourTextView()
    
    let emailCheckButton = SignUpSmallButton("중복 확인")
    let genderSelectSegmentControl = SignUpGenderSegmentControl(items: ["여성", "남성"])
    
    let completeButton = SignUpCompleteButton("완료")
    
    let checkEmailLabel = SignUpCheckEmailLabel()
    let checkPWLabel = SignUpCheckPWLabel()
    let checkNicknameLabel = SignUpCheckNicknameLabel()
    let checkBirthdayLabel = SignUpCheckBirthdayLabel()
    
   // 8, 40
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [emailLabel, pwLabel, nicknameLabel, birthdayLabel, genderLabel, introduceLabel, emailTextField, pwTextField, nicknameTextField, birthdayTextField, introduceTextView, emailCheckButton, genderSelectSegmentControl, completeButton, checkEmailLabel, checkPWLabel, checkNicknameLabel, checkBirthdayLabel].forEach { item in
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
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(40)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        emailCheckButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.width.equalTo(82)
            make.height.equalTo(52)
            make.trailing.equalTo(contentView).inset(18)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).inset(18)
            make.trailing.equalTo(emailCheckButton.snp.leading).offset(-8)
            make.height.equalTo(52)
        }
        checkEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(emailCheckButton.snp.bottom).offset(8)
            make.trailing.equalTo(contentView).inset(18)
        }
        
        pwLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
        }
        pwTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.top.equalTo(pwLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
        }
        checkPWLabel.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(8)
            make.leading.equalTo(contentView).inset(24)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.top.equalTo(pwTextField.snp.bottom).offset(40)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
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
        }
        
        
        

    }
    
    override func setting() {
        super.setting()
        
        emailCheckButton.isEnabled = false
        
        birthdayTextField.keyboardType = .numberPad
    }
    
}
