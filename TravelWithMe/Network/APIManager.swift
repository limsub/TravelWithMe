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

protocol RawEnumConvertible: RawRepresentable, Error {}

enum EnumType1: Int, RawEnumConvertible {
    case caseA = 1
    case caseB
}

enum EnumType2: Int, RawEnumConvertible {
    case caseX = 10
    case caseY
}

func createEnumWithRawValue<T: RawEnumConvertible>(_ rawValue: Int) -> T? {
    return T(rawValue: rawValue as! T.RawValue)
}


class APIManager {
    
    
    
    static let shared = APIManager()
    private init() { }
    
    
    private var header: HTTPHeaders = [
        "Content-Type": "application/json",
        "SesacKey": SeSACAPI.subKey
    ]
    
    
    // 라우터 패턴 함수. 필요한 요소 매개변수로 더 추가해주면 끝. (에러, ...)
    func abc<T: Decodable, U: APIError>(type: T.Type, api: Router, error: U.Type) {
        AF.request(api)
            .responseDecodable(of: T.self) { response  in
                print(response)
                
                let ss = U(rawValue: 200)
                
                let a = CommonAPIError(rawValue: 200)
   
                response.response?.statusCode
                
                ValidEmailAPIError(rawValue: response.response!.statusCode)
                
                U(rawValue: 200 as! U.RawValue)
                
            }
    }
    
    func request<T: Decodable, U: APIError>(type: T.Type, error: U.Type, api: Router) -> Single< Result<T, Error> > {
        
        return Single< Result<T, Error> >.create { single in
            AF.request(api)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        print("네트워크 통신 성공")
                        single(.success(.success(data)))
                        
                    case .failure(_):
                        // 상태 코드로 에러 찾기
                        let statusCode = response.response?.statusCode ?? 500
                        print("네트워크 통신 실패. 상태 코드 \(statusCode)에 따라 에러 탐색")
                        
                        // Common Error에 있는 경우
                        if (statusCode == 420 || statusCode == 429 || statusCode == 444 || statusCode == 500) {
                            let returnError = CommonAPIError(rawValue: statusCode)! // force unwrapping
                            print("에러 내용 : \(returnError.description)")
                            single(.success(.failure(returnError)))
                            
                        }
                        // U Error인 경우
                        else {
                            let returnError = U(rawValue: statusCode)!  // force unwrapping
                            print("에러 내용 : \(returnError.description)")
                            single(.success(.failure(returnError)))
                        }
                    }
                }
            return Disposables.create()
        }
        
    }
    
    // 컷
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
    
    func requestJoin(_ sender: JoinRequest) -> Single< Result< JoinResponse, Error > > {
        
        return Single< Result<JoinResponse, Error> >.create { single in
            
            let urlString = SeSACAPI.baseURL + "/join"
            
            guard let url = URL(string: urlString) else {
                return Disposables.create()
            }
            
            let parameter: Parameters = [
                "email" : sender.email,
                "password": sender.password,
                "nick": sender.nick,
                "phoneNum": sender.gender,
                "birthDay": sender.birthDay
            ]
            
            AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: self.header)
                .validate()
                .responseDecodable(of: JoinResponse.self) { response in
                    print("회원가입 요청")
                    
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
