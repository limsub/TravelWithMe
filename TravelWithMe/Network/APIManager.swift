//
//  APIManager.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/22.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa


class APIManager {
    
    static let shared = APIManager()
    private init() { }
    
    
    private var header: HTTPHeaders = [
        "Content-Type": "application/json",
        "SesacKey": SeSACAPI.subKey
    ]
    
    func requestValidEmail(_ sender: ValidEmailRequest) -> Single< Result< ValidEmailResponse, Error> > {
        
        return Single< Result<ValidEmailResponse, Error> >.create { single in
            
            let urlString = SeSACAPI.baseURL +  "/validation/email"
            
            guard let url = URL(string: urlString) else {
                return Disposables.create()
            }
            
            let parameter: Parameters = [
                "email" : sender.email
            ]
            
            AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: self.header)
                .validate()
                .responseDecodable(of: ValidEmailResponse.self) { response in
                    print("이메일 유효성 검증")
                    
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                        print("성공 : ", data)
                        
                    case .failure(let error):
                        single(.success(.failure(error)))
                        print("실패 : ", error)
                        print("로컬 description : ", error.localizedDescription)
                        print("상태 코드 : ", response.response?.statusCode)
                    }
                }
            return Disposables.create()
        }
    }
    
    func requestJoin(_ joinInfo: JoinRequest) {
        let urlString = SeSACAPI.baseURL + "/join"
        
        guard let url = URL(string: urlString) else { return }
        
        let parameter: Parameters = [
            "email" : joinInfo.email,
            "password": joinInfo.password,
            "nick": joinInfo.nick,
            "phoneNum": joinInfo.phoneNum,
            "birthDay": joinInfo.birthDay
        ]
        
        var request = URLRequest(url: url)
        request.headers = header
        request.method = .post
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: parameter)
        } catch {
            print(error)
        }
        
        AF.request(request)
            .validate(statusCode: 200...500)
            .responseDecodable(of: JoinResponse.self) { response in
                print("회원가입 요청")
                let statusCode = response.response?.statusCode ?? 700
                print("statusCode : ", statusCode)
                
                if statusCode == 200 {
                    print("=== response === : ", response)
                }
            }
    }
    
    func requestLogin(_ loginInfo: LoginRequest) -> Single< Result<LoginResponse, Error> > {
        
        return Single< Result<LoginResponse, Error> >.create { single in
            
            let urlString = SeSACAPI.baseURL + "/login"
            guard let url = URL(string: urlString) else {
                return Disposables.create()
            }
            
            let parameter: Parameters = [
                "email": loginInfo.email,
                "password": loginInfo.password
            ]
            
            
            AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: self.header)
                .validate(statusCode: 200...500)
                .responseDecodable(of: LoginResponse.self) { response  in
                    print("로그인 요청")
                    
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                        print("success : ", data);
                        
                    case .failure(let error):
                        single(.success(.failure(error)))
                        print("failure : ", error)
                        print("localDescription : ", error.localizedDescription)
                        print(response.response?.statusCode)
                    }
                    
                }
            
            
            return Disposables.create()
        }
        
        
        
//        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
//            .validate(statusCode: 200...500)
//            .responseDecodable(of: LoginResponse.self) { response in
//                print("로그인 요청")
//                let statusCode = response.response?.statusCode ?? 700
//                print("statusCode : ", statusCode)
//
//                if statusCode == 200 {
//                    print("===response=== : ", response)
//                }
//            }
    }
    
    func requestWithDraw(_ accessToken: String)  {
        let urlString = SeSACAPI.baseURL + "/withdraw"
        guard let url = URL(string: urlString) else { return }
        
        header.update(name: "Authorization", value: accessToken)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200...500)
            .responseDecodable(of: WithDrawResponse.self) { response  in
                print("탈퇴 요청")
                let statusCode = response.response?.statusCode ?? 700
                print("statusCode : ", statusCode)
                
                if statusCode == 200 {
                    print("=== response === : ", response)
                }
            }
    }
    
    
}
