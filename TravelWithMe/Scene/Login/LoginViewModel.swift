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
                case .success(let result): // let result
                    UserDefaults.standard.set(result.token, forKey: "token")
                    
                    return AttemptLogin.success(result: result)
                case .failure(let error):   // 임시. 추후에 나눌 예정
                    
                    if let commonError = error as? CommonAPIError {
                        return AttemptLogin.commonError(error: commonError)
                    }
                    
                    if let loginError = error as? LoginAPIError {
                        return AttemptLogin.loginError(error: loginError)
                    }
                    
                    // 이건 일어나지 않길 바라야지 뭐...
                    return AttemptLogin.commonError(error: .unknownError)
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
