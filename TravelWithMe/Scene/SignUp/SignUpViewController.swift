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
    
    let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NWRiMWE4OTk1MjdlMTc2MGQwOTZmMSIsImlhdCI6MTcwMDY0MDA1NSwiZXhwIjoxNzAwNjQxODU1LCJpc3MiOiJzZXNhY18zIn0.YzSm9iVKE4B02G38nAI2_eWZNzta_QIRcO7nmIgqrmw"
    
    let refreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MDA2NDAwNTUsImV4cCI6MTcwMDY3NjA1NSwiaXNzIjoic2VzYWNfMyJ9.6cEv3AaQsQHhvRcMeYdWaCQP-hsVmG2l9xlyzBD7kcE"
    
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        APIManager.shared.requestValidEmail("11@naver.commm")
//        APIManager.shared.requestJoin(JoinRequest(email: "aa@naver.com", password: "aaa", nick: "abcd", phoneNum: "male", birthDay: "20231012"))
        

//        APIManager.shared.requestLogin(LoginRequest(email: "aa@naver.com", password: "aaa"))
//        APIManager.shared.requestWithDraw(accessToken)
            
        
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
            emailEditing: mainView.emailTextField.rx.controlEvent(.editingChanged),
            emailText: mainView.emailTextField.rx.text.orEmpty,
            emailCheckButtonClicked: mainView.emailCheckButton.rx.tap,
            pwText: mainView.pwTextField.rx.text.orEmpty,
            nicknameText: mainView.nicknameTextField.rx.text.orEmpty,
            birthdayText: mainView.birthdayTextField.rx.text.orEmpty,
            genderSelectedIndex: mainView.genderSelectSegmentControl.rx.selectedSegmentIndex,
            
            signUpButtonClicked: mainView.completeButton.rx.tap
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
        
        
        // 5. 성별 -> 따로 예외처리 x
        
        // 라스트. 회원가입 버튼 활성화 (모든 객체에 편집 시작해야 작동. 어차피 초기 enabled = false)
        output.validSignUpButton
            .subscribe(with: self) { owner , value in
                print("버튼 체크 === ", value)
                owner.mainView.completeButton.isEnabled = value
                owner.mainView.completeButton.backgroundColor = value ? .red : UIColor(hexCode: ConstantColor.disabledButtonBackground.hexCode)
                
                
            }
            .disposed(by: disposeBag)
        
        // 회원가입 버튼 누른 후 결과
        output.resultSignUpClicked
            .subscribe(with: self) { owner , value in
                switch value {
                case .success:
                    print("회원가입 성공! 다음 화면 전환")
                case .emptyParameter:
                    print("=== 실패 === 빈 칸 존재! 다시 체크")
                case .alreadyRegistered:
                    print("=== 실패 === 이미 가입된 유저!!")
                }
            }
            .disposed(by: disposeBag)
    
    }
}
