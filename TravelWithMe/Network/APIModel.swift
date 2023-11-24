//
//  APIModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/22.
//

import Foundation

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
    let gender: String
    let birthDay: String
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
    let token: String
    let refreshToken: String
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
//    let file: data
    let product_id = SeSACAPI.product_id
    let tourDates: String   // struct TourDates { let dates: [String] }             ["20231011", "20231104", "20231108"]
    let tourLocations: String  // struct TourLocations { let locations: [String] }  [위도, 경도]
    let locationName: String
    let maxPeopleCnt: String  // String(5)
    let tourPrice: String // String(30000)
}

struct MakePostResponse: Decodable {
    let likes: [String]
    let image: [String] // String인지 Data인지 아직 잘 모르겠음
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
