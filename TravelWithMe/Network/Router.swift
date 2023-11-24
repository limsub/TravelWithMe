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
    
    case makePost(sender: MakePostRequest)
    
    
    private var path: String {
        switch self {
        case .validEmail:
            return "/validation/email"
        case .join:
            return "/join"
        case .login:
            return "/login"
        case .makePost:
            return "/post"
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .validEmail, .join, .login:
            return [
                "Content-Type": "application/json",
                "SesacKey": SeSACAPI.subKey
            ]
        case .makePost:
            return [
                "Authorization": SeSACAPI.tempToken,
                "Content-Type": "application/json",
                "SesacKey": SeSACAPI.subKey
            ]
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .validEmail, .join, .login, .makePost:
            return .post
        }
    }
    
    private var parameter: [String: Any] {
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
            return [
                "title": sender.title,
                "content": sender.content,
//                "file": sender.files
                "product_id": sender.product_id,
                "content1": sender.tourDates,
                "content2": sender.tourLocations,
                "content3": sender.locationName,
                "content4": sender.maxPeopleCnt,
                "content5": sender.tourPrice
            ]
        }
        
        
    }
    
//    private var query: [String: String] {
//        switch self {
//
//        }
//    }
     
//    var sesacError: Error.Type {
//        switch self {
//        case .validEmail:
//            return ValidEmailAPIError.self
//        case .join:
//            return JoinAPIError.self
//        }
//    }
    
//    var sesacError: any APIError.Type {
//        switch self {
//        case .validEmail:
//            return ValidEmailAPIError.self
//        case .join:
//            return JoinAPIError.self
//        }
//    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: SeSACAPI.baseURL + path)!
        
        var request = URLRequest(url: url)
        
        request.headers = header
        request.method = method
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameter)
        request.httpBody = jsonData
        
//        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        
        return request
    }
}