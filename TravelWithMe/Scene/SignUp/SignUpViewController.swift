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
        bind()
    }
    
    
    func setNavigation() {
        navigationItem.title = "회원가입"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func bind() {
        
        let input = SignUpViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            emailCheckButtonClicked: mainView.emailCheckButton.rx.tap,
            pwText: mainView.pwTextField.rx.text.orEmpty
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
        
        // 2. 비밀번호 텍스트 -> 비밀번호
        output.validPWFormat
            .subscribe(with: self) { owner , value in
                
                owner.mainView.checkPWLabel.setUpText(value)
                
                print("비밀번호 === ", value)
            }
            .disposed(by: disposeBag)
        
        
    }
}
