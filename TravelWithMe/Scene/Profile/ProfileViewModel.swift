//
//  ProfileViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/29.
//

import UIKit


class ProfileViewModel {
    
    var profileData: LookProfileResponse = LookProfileResponse(
        posts: [], followers: [], following: [], _id: "", email: "", nick: "", phoneNum: nil, birthDay: nil, profile: nil
    )
    
    // 프로필 정보 가져오기
    func fetchData(completionHandler: @escaping (Result<LookProfileResponse, Error>) -> Void) {
        RouterAPIManager.shared.requestNormal(
            type: LookProfileResponse.self,
            error: LookProfileAPIError.self,
            api: .lookMyProfile) { [weak self] response in
                print("== * 프로필 조회 * ==")
                print(response)
                
                switch response {
                case .success(let result):
                    print("프로필 조회 성공")
                    self?.profileData = result
                    completionHandler(.success(result))
                case .failure(let error):
                    print("프로필 조회 실패")
                    completionHandler(.failure(error))
                }
            }
    }
    
}
