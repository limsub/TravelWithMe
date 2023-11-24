//
//  LoginView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/23.
//

import UIKit
import SnapKit

class LoginView: BaseView {
    
    let logoImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let emailLabel = SignUpSmallLabel("이메일 계정")
    let pwLabel = SignUpSmallLabel("비밀번호")
    let emailTextField = SignUpTextField("이메일을 입력해주세요")
    let pwTextField = SignUpTextField("비밀번호를 입력해주세요")
    
    let loginButton = SignUpCompleteButton("로그인")
    let signUpButton = SignUpCompleteButton("회원가입")
    
    let checkLoginLabel = LoginCheckLoginLabel()
    
    override func setConfigure() {
        super.setConfigure()
        
        [logoImageView, emailLabel, emailTextField, pwLabel, pwTextField, loginButton, signUpButton, checkLoginLabel].forEach { item in
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(60)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(120)
            make.height.equalTo(logoImageView.snp.width)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(60)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(52)
        }
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
        }
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(52)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(52)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(18)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(52)
        }
        
        checkLoginLabel.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(8)
            make.trailing.equalTo(self).inset(24)
        }
        
        
        
        
    }
}
