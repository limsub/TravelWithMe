//
//  RouterAPIManager.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/23.
//

import Foundation
import Alamofire
import AlamofireImage
import RxSwift
import RxCocoa



class RouterAPIManager {
    
    static let shared = RouterAPIManager()
    private init() { }
    
    
    // 이미지 다운 (사용 x)
    func requestImage(api: Router, completionHandler: @escaping (Result<Image, Error>) -> Void) {
        
        AF.request(api)
            .responseImage { response in
                print(response)
                switch response.result {
                case .success(let image):
                    print("image 네트워크 성공")
                    
                    completionHandler(.success(image))
                    
                    
                case .failure(let error):
                    print("error 네트워크 실패")
                    
                    completionHandler(.failure(error))
                }
            }
        
    }
    
    // 기본
    func requestNormal<T: Decodable, U: APIError>(type: T.Type, error: U.Type, api: Router, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(api, interceptor: /*nil*/ APIRequestInterceptor())
            .responseDecodable(of: T.self) { response in
                print(response)
                
                switch response.result {
                case .success(let data):
                    print("(노말 네트워크) 통신 성공")
                    completionHandler(.success(data))
                    
                case .failure(let error):
                    
                    let statusCode = response.response?.statusCode ?? 500
                    print("(노말 네트워크) 노말 네트워크 통신 실패. 상태 코드 \(statusCode)에 따라 에러 탐색")
                    
                    
                    // 1. 공통 에러인 경우
                    if [420, 429, 444, 500].contains(statusCode) {
                        print("(노말 네트워크) 공통 에러를 받았습니다")
                        let returnError = CommonAPIError(rawValue: statusCode)!
                        completionHandler(.failure(returnError))
                    }
                    
                    // 2. 리프레시 토큰 에러인 경우
                    else if case .requestRetryFailed(let retryError as RefreshTokenAPIError, _) = error {
                        print("(노말 네트워크) 리프레시 토큰 에러를 받았습니다. 상태 코드와 관계없이 refreshTokenAPIError를 던집니다")
                        completionHandler(.failure(retryError))
                    }

                    // 3. U 타입 에러인 경우
                    else if let returnError = U(rawValue: statusCode) {
                        print("(노말 네트워크) U 타입 에러를 받았습니다")
                        completionHandler(.failure(returnError))
                    }
                    
                }
            }
        
        
    }
    
    // multiPart 용
    func requestMultiPart<T: Decodable, U: APIError>(type: T.Type, error: U.Type, api: Router) -> Single< Result<T, Error> > {
        
        return Single< Result<T, Error> >.create { single in
            AF.upload(multipartFormData: { multipartFormData in
                // 파라미터를 데이터 타입으로 변환
                for (key, value) in api.parameter {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                
                // 이미지 올려주기
                for image in api.imageData {
                    print("=== 이미지 크기 ===")
                    print((Double(image.count)/1024.0)/1024.0)
                    
                    switch api {
                    case .makePost:
                        multipartFormData.append(
                            image,
                            withName: "file",
                            fileName: "image.jpeg",
                            mimeType: "image/jpeg"
                        )
                    case .modifyMyProfile:
                        multipartFormData.append(
                            image,
                            withName: "profile",
                            fileName: "image.jpeg",
                            mimeType: "image/jpeg"
                        )
                    default:
                        break
                    }
                    
                }
            }, to: api.url, method: api.method, headers: api.header, interceptor: APIRequestInterceptor())
            .validate()
            .responseDecodable(of: T.self) { response  in
                switch response.result {
                case .success(let data):
                    print("(multipart) 네트워크 통신 성공")
                    single(.success(.success(data)))
                    
                case .failure(let error):
                    
                    print("(multipart) 에러 내용 : ", error)
                    let statusCode = response.response?.statusCode ?? 500
                    print("(multipart) 네트워크 통신 실패. 상태 코드 '\(statusCode)'에 따라 에러 탐색")
                    
                    
                    // 1. 공통 에러인 경우
                    if [420, 429, 444, 500].contains(statusCode) {
                        print("(multipart) 공통 에러를 받았습니다")
                        let returnError = CommonAPIError(rawValue: statusCode)!
                        single(.success(.failure(returnError)))
                        return
                    }
                    
                    
                    // 2. 리프레시 토큰 에러인 경우
                    else if case .requestRetryFailed(let retryError as RefreshTokenAPIError, _) = error {
                        print("(multipart) 리프레시 토큰 에러를 받았습니다. 상태 코드와 관계없이 refreshTokenAPIError를 던집니다")
                        single(.success(.failure(retryError)))
                    }
                    
                    // 3. U 타입 에러인 경우
                    else if let returnError = U(rawValue: statusCode) {
                        print("(multipart) U 타입 에러를 받았습니다")
                        print("(multipart) 에러 내용 : \(returnError.description)")
                        single(.success(.failure(returnError)))
                    }
                }
            }
            return Disposables.create()
        }
        
        
    }
    
    // 기본 - Single 리턴
    func request<T: Decodable, U: APIError>(type: T.Type, error: U.Type, api: Router) -> Single< Result<T, Error> > {
        
        return Single< Result<T, Error> >.create { single in
            AF.request(api, interceptor: APIRequestInterceptor())
                .validate()
                .responseDecodable(of: T.self) { response in

                    switch response.result {
                    case .success(let data):
                        print("(Single) 네트워크 통신 성공")
                        single(.success(.success(data)))
                        
                    case .failure(let error):
                        
                        print("(Single) 에러 내용 : ", error.localizedDescription)
                        let statusCode = response.response?.statusCode ?? 500
                        print("(Single) 네트워크 통신 실패. 상태 코드 '\(statusCode)'에 따라 에러 탐색")
                        
                        // 1. 공통 에러인 경우
                        if [420, 429, 444, 500].contains(statusCode) {
                            print("(Single) 공통 에러를 받았습니다")
                            let returnError = CommonAPIError(rawValue: statusCode)!
                            single(.success(.failure(returnError)))
                        }
                        
                        
                        // 2. 리프레시 토큰 에러인 경우
                        else if case .requestRetryFailed(let retryError as RefreshTokenAPIError, _) = error {
                            print("(Single) 리프레시 토큰 에러를 받았습니다. 상태 코드와 관계없이 refreshTokenAPIError를 던집니다")
                            single(.success(.failure(retryError)))
                        }
                        
                        
                        // 3. U 타입 에러인 경우
                        else if let returnError = U(rawValue: statusCode) {
                            print("(Single) U 타입 에러를 받았습니다")
                            print("(Single) 에러 내용 : \(returnError.description)")
                            single(.success(.failure(returnError)))
                        }

                    }
                }
            
            return Disposables.create()
        }
//        .debug()
    }
}
