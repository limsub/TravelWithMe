//
//  SplashViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/13/23.
//

import Foundation

enum SetFirstView {
    case loginView
    case mainView
}

class SplashViewModel {
    
    var nextPage: SetFirstView = .loginView
    
    // 현재 키체인에 저장된 토큰이 유효한지 판단한다
    func testToken() {
        
        RouterAPIManager.shared.requestNormalWithNoIntercept(
            type: RefreshTokenResponse.self,
            error: RefreshTokenAPIError.self,
            api: .refreshToken) { response in
                switch response {
                case .success(let result):
                    print("(Splash) 토큰 갱신 성공 - 메인 화면으로 전환")
                    self.setUpKeychainInfo(result: result)
                    self.nextPage = .mainView
                    
                case .failure(let error):

                    if let refreshTokenError = error as? RefreshTokenAPIError,
                        refreshTokenError == .notExpired {
                        print("(Splash) 토큰 갱신 실패(but 409) -> 메인 화면으로 전환")
                        print(refreshTokenError.description)
                        self.nextPage = .mainView
                            
                        return
                    }
                    
                    print("(Splash) 토큰 갱신 싪패  - 로그인 화면으로 전환")
                    self.initKeychainInfo()
                    self.nextPage = .loginView
                }
            }
    }
    
    
    func setUpKeychainInfo(result: RefreshTokenResponse) {
        KeychainStorage.shared.accessToken = result.token
    }
    
    func initKeychainInfo() {
        KeychainStorage.shared.removeAllKeys()
    }
    
    
}
