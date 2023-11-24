//
//  LoginViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/23.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let pwText: ControlProperty<String>
        let loginButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let enabledLoginButton: Observable<Bool>
        let resultLogin: PublishSubject<AttemptLogin>
    }
    
    func tranform(_ input: Input) -> Output {
        
        // 1. 두 텍스트필드에 모두 입력값이 있을 때, enabledLoginButton true
        let enabledLoginButton = Observable.combineLatest(input.emailText, input.pwText) { v1, v2 in
            
            return (!v1.isEmpty && !v2.isEmpty)
        }
        
        
        // 2. loginButton 클릭 시, 네트워크 통신 후 결과 전달
        let loginInfo = Observable.combineLatest(input.emailText, input.pwText) { v1, v2 in
            
            return LoginRequest(email: v1, password: v2)
        }
        let resultLogin = PublishSubject<AttemptLogin>()
        input.loginButtonClicked
            .withLatestFrom(loginInfo)
            .flatMap { value in
                RouterAPIManager.shared.request(
                    type: LoginResponse.self,
                    error: LoginAPIError.self,
                    api: .login(sender: value)
                )
            }
            .map { response in
                switch response {
                case .success(_): // let result
                    return AttemptLogin.success
                case .failure(_):
                    return AttemptLogin.emptyParameter
                }
            }
            .subscribe(with: self) { owner, value in
                resultLogin.onNext(value)
            }
            .disposed(by: disposeBag)
        
        return Output(
            enabledLoginButton: enabledLoginButton,
            resultLogin: resultLogin
        )
    }
}
