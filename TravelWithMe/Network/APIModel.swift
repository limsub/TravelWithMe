//
//  APIModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/22.
//

import Foundation
//import UIKit    // file 저장을 [UIImage]..


/* ===== 이메일 중복 확인 ===== */
struct ValidEmailRequest: Encodable {
    let email: String
}

struct ValidEmailResponse: Decodable {
    let message: String
}



/* ===== 회원가입 ===== */
struct JoinRequest: Encodable {
    let email: String
    let password: String
    let nick: String
//    let gender: String
//    let birthDay: String
}

struct JoinResponse: Decodable {
    let _id: String
    let email: String
    let nick: String
}



/* ===== 로그인 ===== */
struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let _id: String
    let token: String
    let refreshToken: String
}


/* ===== 토큰 갱신 ===== */
struct RefreshTokenResponse: Decodable {
    let token: String
}


/* ===== 탈퇴 (only response) ===== */
struct WithDrawResponse: Decodable {
    let _id: String
    let email: String
    let nick: String
}


/* === 포스트 작성 === */
struct MakePostRequest: Encodable {
    let title: String
    let content: String
    let file: [Data]
    let product_id = SeSACAPI.product_id
    let tourDates: String   // struct TourDates { let dates: [String] }             ["20231011", "20231104", "20231108"]
    let tourLocations: String // struct TourLocations { let name: String, let latitude: Double, let longtitude: Double }
    let maxPeopleCnt: String  // String(5)
    let tourPrice: String // String(30000)
}

struct MakePostResponse: Decodable {
    let likes: [String]
    let image: [String] // String인지 Data인지 아직 잘 모르겠음 -> String으로 결론. 서버 내에 이미지가 저장된 url을 받는다.
    let hashTags: [String]
    let comments: [String]
    let _id: String
    let creator: Creator
    let time: String
    let title: String
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let content5: String
    let product_id: String
}

struct Creator: Codable {
    let _id: String
    let nick: String
}


/* ===== 포스트 조회 ===== */
struct LookPostQueryString {
    let next: String
    let limit: String
    let product_id = SeSACAPI.product_id
}

struct LookPostResponse: Decodable {
    let data: [Datum]
    let nextCursor: String

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

struct Datum: Codable {
    var likes: [String]
    let image: [String]
    let hashTags, comments: [String]
    let id: String
    let creator: Creator
    let time: String
    let title: String?       // 제목
    let content: String     // 소개 (내용)
    let dates: String       // content1. 날짜 struct json string
    let location: String    // content2. 장소 struct json string
    let maxPeopleCnt: String? // content3. 최대 인원수
    let price: String?       // content4. 예상 가격
    let content5: String?    // 미정
    let productID: String

    enum CodingKeys: String, CodingKey {
        case likes, image, hashTags, comments
        case id = "_id"
        case creator, time, title, content
        
        case dates = "content1"
        case location = "content2"
        case maxPeopleCnt = "content3"
        case price = "content4"
        
        case content5
        case productID = "product_id"
    }
}


/* ==== 포스트 삭제 ===== */
struct DeletePostRequest {
    let id: String
}

struct DeletePostRespose: Decodable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}


/* ==== 포스트 좋아요 ==== */
struct LikePostRequest {
    let id: String
}
struct LikePostResponse: Decodable {
    let like_status: Bool
}


/* === (내) 프로필 조회 === */

struct LookProfileResponse: Decodable {
    let posts: [String]
    let followers: [String]
    let following: [String]
    let _id: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profile: String? // ????
}
