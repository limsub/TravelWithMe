//
//  RouterAPIManager.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/23.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa



class RouterAPIManager {
    
    static let shared = RouterAPIManager()
    private init() { }
    
    // 기본
    func requestNormal<T: Decodable, U: APIError>(type: T.Type, error: U.Type, api: Router, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(api, interceptor: nil /*APIRequestInterceptor()*/)
            .responseDecodable(of: T.self) { response in
                print(response)
                
                switch response.result {
                case .success(let data):
                    print("노말 네트워크 통신 성공")
                    completionHandler(.success(data))
                    
                case .failure:
                    
                    let statusCode = response.response?.statusCode ?? 500
                    print("노말 네트워크 통신 실패. 상태 코드 \(statusCode)에 따라 에러 탐색")
                    
                    if [420, 429, 444, 500].contains(statusCode) {
                        let returnError = CommonAPIError(rawValue: statusCode)!
                        print("에러 내용 : \(returnError.description)")
                        completionHandler(.failure(returnError))
                    } else {
                        guard let returnError = U(rawValue: statusCode) else { return }
                        print("에러 내용 : \(returnError.description)")
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
                    
                    let imageHash = String(image.hashValue)
                    
                    multipartFormData.append(
                        image,
                        withName: "file",
                        fileName: "image.jpeg",
                        mimeType: "image/jpeg"
                    )
                }
            }, to: api.url, method: api.method, headers: api.header, interceptor: APIRequestInterceptor())
            .validate()
            .responseDecodable(of: T.self) { response  in
                switch response.result {
                case .success(let data):
                    print("네트워크 통신 성공")
                    single(.success(.success(data)))
                    
                case .failure(let error):
                    
                    print("에러 내용 : ", error)
                    
                    let statusCode = response.response?.statusCode ?? 500
                    print("네트워크 통신 실패. 상태 코드 '\(statusCode)'에 따라 에러 탐색")
                    
                    if [420, 429, 444, 500].contains(statusCode) {
                        let returnError = CommonAPIError(rawValue: statusCode)!
                        print("에러 내용 : \(returnError.description)")
                        single(.success(.failure(returnError)))
                    } else {
                        guard let returnError = U(rawValue: statusCode) else { return }
                        print("에러 내용 : \(returnError.description)")
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
                        print("네트워크 통신 성공")
                        single(.success(.success(data)))
                        
                    case .failure(let error):
                        
                        print("에러 내용 : ", error)
                        
                        let statusCode = response.response?.statusCode ?? 500
                        print("네트워크 통신 실패. 상태 코드 '\(statusCode)'에 따라 에러 탐색")
                        
                        if [420, 429, 444, 500].contains(statusCode) {
                            let returnError = CommonAPIError(rawValue: statusCode)!
                            print("에러 내용 : \(returnError.description)")
                            single(.success(.failure(returnError)))
                        } else {
                            guard let returnError = U(rawValue: statusCode) else { return }
//                            let returnError = U(rawValue: statusCode)!
                            print("에러 내용 : \(returnError.description)")
                            single(.success(.failure(returnError)))
                        }
                    }
                }
            
            return Disposables.create()
        }
//        .debug()
    }
}
