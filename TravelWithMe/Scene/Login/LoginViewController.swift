//
//  LoginViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/23.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    
    let mainView = LoginView()
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        
        let input = LoginViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            pwText: mainView.pwTextField.rx.text.orEmpty,
            loginButtonClicked: mainView.loginButton.rx.tap
        )
        
        let output = viewModel.tranform(input)
        
        // 1. 텍스트필드에 값이 있을 때만 버튼 활성화
        output.enabledLoginButton
            .subscribe(with: self) { owner , value in
                owner.mainView.loginButton.isEnabled = value
                owner.mainView.loginButton.backgroundColor = UIColor(hexCode: value ? ConstantColor.enabledButtonBackground.hexCode : ConstantColor.disabledButtonBackground.hexCode)
            }
            .disposed(by: disposeBag)
        
        // 2. 로그인 버튼 클릭의 결과
        output.resultLogin
            .subscribe(with: self) { owner , value in
                switch value {
                case .success:
                    print("로그인 성공! 다음 화면 전환")
                case .emptyParameter:
                    print("로그인 실패! 빈 칸 존재! 다시 체크")
                case .invalidAccount:
                    print("로그인 실패! 존재하지 않는 유저이거나 비밀번호 틀림")
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
}
