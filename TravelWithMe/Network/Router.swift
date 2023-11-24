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
    
    
    private var path: String {
        switch self {
        case .validEmail:
            return "/validation/email"
        case .join:
            return "/join"
        case .login:
            return "/login"
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .validEmail, .join, .login:
            return [
                "Content-Type": "application/json",
                "SesacKey": SeSACAPI.subKey
            ]
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .validEmail, .join, .login:
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
