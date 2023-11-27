//
//  Router.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/22.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case validEmail(sender: ValidEmailRequest)
    case join(sender: JoinRequest)
    case login(sender: LoginRequest)
    
    case refreshToken   // get 이기 때문에 바디가 없다.
    
    case makePost(sender: MakePostRequest)
    
    var path: String {
        switch self {
        case .validEmail:
            return "/validation/email"
        case .join:
            return "/join"
        case .login:
            return "/login"
        case .refreshToken:
            return "/refresh"
        case .makePost:
            return "/post"
        }
    }
    
    var url: URL {
        URL(string: SeSACAPI.baseURL + path)!
    }
    
    var header: HTTPHeaders {
        switch self {
        case .validEmail, .join, .login:
            return [
                "Content-Type": "application/json",
                "SesacKey": SeSACAPI.subKey
            ]
        case .refreshToken:
            return [
                "Authorization": KeychainStorage.shared.accessToken ?? "",
                "SesacKey": SeSACAPI.subKey,
                "Refresh": KeychainStorage.shared.refreshToken ?? ""
            ]
        case .makePost:
            return [
                "Authorization": KeychainStorage.shared.accessToken ?? "",
                "Content-Type": "multipart/form-data",
                "SesacKey": SeSACAPI.subKey
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .validEmail, .join, .login, .makePost:
            return .post
        case .refreshToken:
            return .get
        }
    }
    
    var parameter: [String: Any] {
        switch self {
        case .validEmail(let sender):
            return [
                "email" : sender.email
            ]
        case .join(let sender):
            return [
                "email" : sender.email,
                "password": sender.password,
                "nick": sender.nick,
                "phoneNum": sender.gender,
                "birthDay": sender.birthDay
            ]
            
        case .login(let sender):
            return [
                "email": sender.email,
                "password": sender.password
            ]
        case .makePost(let sender):
            // 이미지(file)는 파라미터에 넣지 않고, 따로 data로 변환시켜서 전달한다
            return [
                "title": sender.title,
                "content": sender.content,
//                "file": sender.files
                "product_id": sender.product_id,
                "content1": sender.tourDates,
                "content2": sender.tourLocations,
                "content3": sender.maxPeopleCnt,
                "content4": sender.tourPrice,
                "content5": ""
            ]
        default:
            return [:]
        }
    }
    
    var imageData: [Data] {
        switch self {
        case .validEmail, .join, .login, .refreshToken:
            return []
        case .makePost(let sender):
            return sender.file
        }
    }
    
//    private var query: [String: String] {
//        switch self {
//
//        }
//    }
     
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: SeSACAPI.baseURL + path)!
        
        var request = URLRequest(url: url)
        
        request.headers = header
        request.method = method
        
        // get이 아닐 때,
        if method != .get {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameter)
            request.httpBody = jsonData
        }
        
//        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        
        return request
    }
}
