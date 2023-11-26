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
    
    func request<T: Decodable, U: APIError>(type: T.Type, error: U.Type, api: Router) -> Single< Result<T, Error> > {
        
        return Single< Result<T, Error> >.create { single in
            
            AF.request(api)
                .validate(statusCode: 200...200)
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
