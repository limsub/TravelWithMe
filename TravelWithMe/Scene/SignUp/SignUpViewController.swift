//
//  SignUpViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController {
    
    let mainView = SignUpView()
    let viewModel = SignUpViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setNavigation()
        settingBirthTextField()
        bind()
    }
    
    
    func setNavigation() {
        navigationItem.title = "회원가입"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func settingBirthTextField() {
        mainView.birthdayTextField.rx.text
            .orEmpty
            .scan("") { (previous, new) -> String in
                // 최대 입력 길이를 초과하면 이전 값으로 돌아감
                return new.count <= 8 ? new : previous
            }
            .bind(to: mainView.birthdayTextField.rx.text)
            .disposed(by: disposeBag)
    }

    
    func bind() {
        
        let input = SignUpViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            emailCheckButtonClicked: mainView.emailCheckButton.rx.tap,
            pwText: mainView.pwTextField.rx.text.orEmpty,
            nicknameText: mainView.nicknameTextField.rx.text.orEmpty,
            birthdayText: mainView.birthdayTextField.rx.text.orEmpty
        )
        
        
        let output = viewModel.tranform(input)
        
        
        // 1. (이메일 텍스트, 버튼 클릭) -> 이메일 체크 레이블 적용
        output.validEmailFormat
            .subscribe(with: self) { owner , value in
                owner.mainView.checkEmailLabel.setUpText(value)
                
                if value == .invalidFormat || value == .nothing {
                    owner.mainView.emailCheckButton.isEnabled = false
                    owner.mainView.emailCheckButton.backgroundColor = .lightGray
                } else {
                    owner.mainView.emailCheckButton.isEnabled = true
                    owner.mainView.emailCheckButton.backgroundColor = .red
                }
                
                
            }
            .disposed(by: disposeBag)
        
        // 2. 비밀번호 텍스트 -> 비밀번호 체크 레이블
        output.validPWFormat
            .subscribe(with: self) { owner , value in
                owner.mainView.checkPWLabel.setUpText(value)
            }
            .disposed(by: disposeBag)
        
        // 3. 닉네임 텍스트 -> 닉네임 체크 레이블
        output.validNicknameFormat
            .subscribe(with: self) { owner , value in
                owner.mainView.checkNicknameLabel.setUpText(value)
            }
            .disposed(by: disposeBag)
        
        // 4. 생년월일 텍스트 -> 생년월일 체크 레이블
        output.validBirthdayFormat
            .subscribe(with: self) { owner , value in
                owner.mainView.checkBirthdayLabel.setUpText(value)
            }
            .disposed(by: disposeBag)
        
    }
}
