//
//  SettingViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/15/23.
//

import Foundation

class SettingViewModel {
    
    let settingList = ["로그아웃", "회원 탈퇴"]
    
    
    func logout() {
        
    }
    
    
    func withdraw(completionHandler: @escaping (Result<WithdrawResponse, Error>) -> Void) {
        // 회원 탈퇴 api
        RouterAPIManager.shared.requestNormal(
            type: WithdrawResponse.self,
            error: WithdrawAPIError.self,
            api: .withdraw) { response in
                switch response {
                case .success(let result):
                    completionHandler(.success(result))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }

    }
    
    
    
}
