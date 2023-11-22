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
