//
//  APIRequestInterceptor.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import Foundation
import Alamofire

final class APIRequestInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        // retry 후 새로 갱신된 토큰이 키체인에 저장되어 있을 수도 있기 때문에 헤더에 토큰 값을 업데이트해준다.
        var urlRequest = urlRequest
        // add에 update에서, 이미 있는 키면 값을 업데이트하고, 없는 키면 새로 추가한다.
        // 여기서는 새로 추가한다.
        print("adapt 함수 실행. keychain의 토큰값을 헤더에 저장")
        urlRequest.headers.add(name: "Authorization", value: KeychainStorage.shared.accessToken ?? "")
        completion(.success(urlRequest))
        
        // 만약 토큰 갱신을 위한 상황이라면? refreshToken이 필요하다
        // 근데 refreshToken은 새로 갱신되서 들어올 일이 없기 때문에 초기 header에 넣어준 값이 호출 중에 바뀔 일은 없다. 그니까 여기서 안넣어줘도 됨.
    }
    
    
    
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        // 네트워크 에러가 발생하면 retry 함수가 실행된다
        // 이 때, access token 만료 에러 (419) 일 때만, 여기서 처리하고,
        // 기타 에러인 경우 처리해줄 일이 없다.
        
        print("네트워크 에러나서 retry 함수 실행")
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            print("토큰 만료 에러가 아니기 때문에 넘어간다")
            completion(.doNotRetryWithError(error))
            return
        }
        
        print("토큰 만료 에러. 토큰 갱신 네트워크 요청 실행")
        RouterAPIManager.shared.requestNormal(
            type: RefreshTokenResponse.self,
            error: RefreshTokenAPIError.self,
            api: .refreshToken) { response  in
                switch response {
                case .success(let result):
                    
                    // 키체인에 새로운 토큰 저장
                    print("토큰 갱신 성공. 키체인에 새로운 토큰값을 저장합니다")
                    KeychainStorage.shared.accessToken = result.token
                    
                    print("키체인에 토큰 업데이트 완료. api 호출 재실행")
                    completion(.retry)
                    
                    return
                case .failure(let error):
                    print("토큰 갱신 실패")

                    if let commonError = error as? CommonAPIError {
                        print("  공통 에러 중 하나")
                        completion(.doNotRetryWithError(commonError))
                        return
                    }
                    
                    if let refreshTokenError = error as? RefreshTokenAPIError {
                        print("  토큰 갱신 에러 던집니다")
                        completion(.doNotRetryWithError(refreshTokenError))
                        return
                    }
                    
                    completion(.doNotRetryWithError(error))
                }
            }
        
        
    }
    
}
