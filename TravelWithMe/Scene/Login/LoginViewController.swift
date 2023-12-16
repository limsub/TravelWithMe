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
        settingTextFields()
    }
    
    func bind() {
        
        let input = LoginViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            pwText: mainView.pwTextField.rx.text.orEmpty,
            loginButtonClicked: mainView.loginButton.rx.tap,
            signUpButtonClicked: mainView.signUpButton.rx.tap
        )
        
        let output = viewModel.tranform(input)
        
        // 1. 텍스트필드에 값이 있을 때만 버튼 활성화
        output.enabledLoginButton
            .subscribe(with: self) { owner , value in
                owner.mainView.loginButton.update(value ? .enabled : .disabled)
                
            }
            .disposed(by: disposeBag)
        
        // 2. 로그인 버튼 클릭의 결과
        output.resultLogin
            .subscribe(with: self) { owner , value in
                
                switch value {
                case .success:  // 결과값 (result)는 토큰 저장 용으로만 사용하고, 이 과정은 viewModel에서 끝난다. 여기서는 화면 전환만 시켜주면 됨
                    print("로그인 성공! 다음 화면 전환! (window rootView 교체!!!")
                    
                    self.showNoButtonAlert("로그인 성공 🎉🎉", message: "나와 맞는 여행을 찾아보세요") {
                        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                        let sceneDelegate = windowScene?.delegate as? SceneDelegate
                        
                        let vc = StartTabBarViewController()
                        sceneDelegate?.window?.rootViewController = vc
                        sceneDelegate?.window?.makeKeyAndVisible()
                    }
                   
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
        
        
        // 3. 회원가입 화면전환
        output.signUpButtonClicked
            .subscribe(with: self) { owner , _ in
                let vc = SignUpViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func settingTextFields() {
        mainView.emailTextField.delegate = self
        mainView.pwTextField.delegate = self
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case mainView.emailTextField:
            mainView.pwTextField.becomeFirstResponder()
            
        case mainView.pwTextField:
            textField.resignFirstResponder()
            
        default:
            break
        }
        
        return true
    }
}
