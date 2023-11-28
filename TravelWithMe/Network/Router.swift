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
    case lookPost(query: LookPostQueryString) // get이기 때문에 바디 대신 쿼리 스트링에 적을 내용을 전달받는다.
    
    case imageDownload(sender: String)
    
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
        case .makePost, .lookPost:
            return "/post"
        case .imageDownload(let urlString):
            return "/" + urlString
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
        case .lookPost, .imageDownload:
            return [
                "Authorization": KeychainStorage.shared.accessToken ?? "",
                "SesacKey": SeSACAPI.subKey
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .validEmail, .join, .login, .makePost:
            return .post
        case .refreshToken, .lookPost, .imageDownload:
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
        default:    // get인 경우, 빈 딕셔너리 리턴하고, asURLRequest에서 아예 분기처리
            return [:]
        }
    }
    
    var imageData: [Data] {
        switch self {
        case .makePost(let sender):
            return sender.file
        default:
            return []
        }
    }
    
    private var query: [String: String] {
        switch self {
        case .lookPost(let queryString):
            return [
                "next": queryString.next,
                "limit": queryString.limit,
                "product_id": queryString.product_id
            ]
        default:
            return [:]
        }
        
    }
     
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: SeSACAPI.baseURL + path)!
        
        var request = URLRequest(url: url)
        
        request.headers = header
        request.method = method
        
        // get이 아닐 때 파리미터
        if method != .get {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameter)
            request.httpBody = jsonData
            
            return request
        }
        
        // get일 때 쿼리스트링
        else {
            guard let urlString = request.url?.absoluteString else { return request }
            
            var components = URLComponents(string: urlString)
            components?.queryItems = []
            
            
            for (key, value) in query {
                print("키 : \(key), 밸류 : \(value)")
                components?.queryItems?.append(URLQueryItem(name: key, value: value))
            }
            
            guard let newURL = components?.url else { return request }
            
            print("새로운 url : ", newURL.absoluteString)
            
            var newURLRequest = URLRequest(url: newURL)
            newURLRequest.headers = header
            newURLRequest.method = method
            
            return newURLRequest
        }

    }
}
