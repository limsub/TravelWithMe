//
//  ProfileViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/29.
//

import UIKit


class ProfileViewModel {
    
    var userType = UserType.me
    
    
    var profileData: LookProfileResponse = LookProfileResponse(
        posts: [], followers: [], following: [], _id: "", email: "", nick: "", phoneNum: nil, birthDay: nil, profile: nil
    )
    
    // 프로필 정보 가져오기
    func fetchData(completionHandler: @escaping (Result<LookProfileResponse, Error>) -> Void) {
        RouterAPIManager.shared.requestNormal(
            type: LookProfileResponse.self,
            error: LookProfileAPIError.self,
            api: .lookProfile(usetType: self.userType)) { [weak self] response in
                print("== * 프로필 조회 * ==")
//                print(response)
                print(self?.userType)
                
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
    
    // (X) 내 프로필 정보를 가져와서, 현재 보고 있는 프로필 유저를 내가 팔로우했는지 여부를 반환한다
    // 생각해보니까 이 유저 프로필을 받아왔으니까 그 배열 내에 내 id가 있는지 확인하면 되겠다.
    func checkFollowOrNot(_ userID: String, completionHandler: @escaping (Bool) -> Void) {
        
        let ans = profileData.followers.contains { creator in
            creator._id == KeychainStorage.shared._id
        }
        
        completionHandler(ans)
        
    }
    
    func followOrUnfollow(follow: Bool, completionHandler: @escaping (Result<FollowResponse, Error>) -> Void) {
        
        if follow {
            // 팔로우하기
            RouterAPIManager.shared.requestNormal(
                type: FollowResponse.self,
                error: FollowAPIError.self,
                api: .follow(sender: FollowRequest(
                    id: profileData._id,
                    followBool: true))) { response in
//                        print("-- 팔로우하기 결과 --")
//                        print(response)
                        switch response {
                        case .success(let result):
                            print("-- 팔로우 성공")
                            completionHandler(.success(result))
                        case .failure(let error):
                            print("-- 팔로우 실패")
                            completionHandler(.failure(error))
                        }
                    }
            
        } else {
            // 언팔로우하기
            RouterAPIManager.shared.requestNormal(
                type: FollowResponse.self,
                error: UnFollowAPIError.self,
                api: .follow(sender: FollowRequest(
                    id: profileData._id,
                    followBool: false))) { response  in
//                        print("-- 언팔로우하기 결과 --")
//                        print(response)
                        
                        switch response {
                        case .success(let result):
                            print("-- 언팔로우 성공")
                            completionHandler(.success(result))
                        case .failure(let error):
                            print("-- 언팔로우 실패")
                            completionHandler(.failure(error))
                        }
                    }
            
        }
                
    }
    
}
