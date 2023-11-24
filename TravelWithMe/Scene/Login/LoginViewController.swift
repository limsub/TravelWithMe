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
                case .success(let result):
                    print("로그인 성공! 다음 화면 전환!")
                    print("== 토큰 ==")
                    print(" - 액세스 토큰 : \(result.token)")
                    print(" - 리푸레시 토큰 : \(result.refreshToken)")
                    
                case .commonError(let error):
                    print("공통 에러 발생!")
                    // 뷰컨트롤러 함수 하나 만들어서 에러 종류별로 얼럿 띄워주기

                case .loginError(let error):
                    print("로그인 실패!")
                    owner.mainView.checkLoginLabel.setUpText(error)
                    switch error {
                    case .inValidAccount:
                        print("== 아이디 또는 비밀번호 불일치")
                    case .missingValue:
                        print("== 빈 칸 존재!")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
}
