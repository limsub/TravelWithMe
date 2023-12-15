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
    case modifyPost(sender: MakePostRequest, poseID: String)
    
    // userId를 넣으면 유저 별 조회, nil이면 전체 유저 조회라고 판단
    // hashTag가 있으면 특정 해시태그 게시글 조회. nil이면 전체 게시글 조회
    // likePost가 true이면 내가 좋아요한 게시글 조회. false(디폴트)이면 x
    case lookPost(
        query: LookPostQueryString,
        userId: String? = nil,
        hashTag: String? = nil,
        likePost: Bool = false
    ) // get이기 때문에 바디 대신 쿼리 스트링에 적을 내용을 전달받는다.
    
    case deletePost(idStruct: DeletePostRequest)
    
    case likePost(idStruct: LikePostRequest)
    
//    case lookMyProfile
    
    case lookProfile(usetType: UserType)
    case modifyMyProfile(sender: ModifyMyProfileRequest)
    
    case makeReview(sender: MakeReviewRequest, postID: String)
    
    case follow(sender: FollowRequest)

//    case lookLikePost
    
    case imageDownload(sender: String)  // (사용 x)
    
    
    
    
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
        case .modifyPost(_, let postID):
            return "/post/\(postID)"
            
        case .lookPost(_, let userID, let hashTag, let likePost):
            if let userID {
                return "/post/user/\(userID)"
            }
            if hashTag != nil {
                return "/post/hashTag"
            }
            if likePost {
                return "/post/like/me"
            }
            else {
                return "/post"
            }
            
            
            
        case .deletePost(let idStruct):
            return "/post/\(idStruct.id)"
            
        case .likePost(let idStruct):
            return "/post/like/\(idStruct.id)"
            
//        case .lookMyProfile:
//            return "/profile/me"
            
        case .lookProfile(let userType):
            switch userType {
            case .me:
                return "/profile/me"
            case .other(let userId, _):
                return "/profile/\(userId)"
            }
            
        case .modifyMyProfile:
            return "/profile/me"
            
        case .makeReview(_, let postID):
            return "/post/\(postID)/comment"
            
        case .follow(sender: let idStruct):
            return "/follow/\(idStruct.id)"
            
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
        case .makePost, .modifyPost, .modifyMyProfile:
            return [
                "Authorization": KeychainStorage.shared.accessToken ?? "",
                "Content-Type": "multipart/form-data",
                "SesacKey": SeSACAPI.subKey
            ]
        case .makeReview:
            return [
                "Authorization": KeychainStorage.shared.accessToken ?? "",
                "Content-Type": "application/json",
                "SesacKey": SeSACAPI.subKey
            ]
        case .lookPost, .deletePost, .likePost, .lookProfile, .follow, .imageDownload:
            return [
                "Authorization": KeychainStorage.shared.accessToken ?? "",
                "SesacKey": SeSACAPI.subKey
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .validEmail, .join, .login, .makePost, .likePost, .makeReview:
            return .post
            
        case .refreshToken, .lookPost, .lookProfile, .imageDownload:
            return .get
            
        case .deletePost:
            return .delete
            
        case .follow(let followRequest):
            if followRequest.followBool {
                return .post    // true : 팔로우 : post
            } else {
                return .delete  // false : 언팔로우 : delete
            }
            
        case .modifyPost, .modifyMyProfile:
            return .put
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
//                "phoneNum": sender.gender,
//                "birthDay": sender.birthDay
            ]
            
        case .login(let sender):
            return [
                "email": sender.email,
                "password": sender.password
            ]
        case .makePost(let sender), .modifyPost(let sender, _):
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
        case .makeReview(let sender, _):
            return [
                "content": sender.content
            ]
        case .modifyMyProfile(let sender):
//            return ["hihihih": 123123123]
            return ["nick": sender.nick]
        default:    // get인 경우, 빈 딕셔너리 리턴하고, asURLRequest에서 아예 분기처리
            return [:]
        }
    }
    
    var imageData: [Data] {
        switch self {
        case .makePost(let sender), .modifyPost(let sender, _):
            return sender.file
        case .modifyMyProfile(let sender):
            guard let profileData = sender.profile else {
                return []
            }
            return [profileData]
        default:
            return []
        }
    }
    
    private var query: [String: String] {
        switch self {
        case .lookPost(let queryString, _, let hashTag, let likePost):
            
            if let hashTag {
                
                return [
                    "next": queryString.next,
                    "limit": queryString.limit,
                    "product_id": queryString.product_id,
                    "hashTag": hashTag
                ]
                
            }
            
            if likePost {
                return [
                    "next": queryString.next,
                    "limit": queryString.limit
                ]
            }
            
            else {
                return [
                    "next": queryString.next,
                    "limit": queryString.limit,
                    "product_id": queryString.product_id
                ]
            }
            
        default:
            return [:]
        }
        
    }
     
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: SeSACAPI.baseURL + path)!
        
        var request = URLRequest(url: url)
        
        request.headers = header
        request.method = method
        
        // post일 때 파라미터
        if method == .post {
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
