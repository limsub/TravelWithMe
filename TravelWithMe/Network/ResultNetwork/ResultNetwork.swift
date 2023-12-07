//
//  ResultNetwork.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/24.
//

import Foundation

/*
 네트워크 통신 후 성공 or 실패 받고,
    - 성공 : data 응답
    - 실패 : APIError
 
 ViewController에 Output으로 전달해주기 위한 enum
 */


/* === 이메일 유효성 검사 === */
// - SignUp의 ValidEmail로 대응

/* === 회원가입 === */
enum AttemptSignUp {
    case success
    case emptyParameter
    case alreadyRegistered
}



/* === 로그인 === */
enum AttemptLogin {
//    case success(result: LoginResponse)
    case success(result: LoginResponse)
    case commonError(error: CommonAPIError)
    case loginError(error: LoginAPIError)
}


/* === 게시글 작성 === */
enum AttemptMakePost {
    case success(result: MakePostResponse)
    case commonError(error: CommonAPIError)
    case makePostError(error: MakePostAPIError)
    case refreshTokenError(error: RefreshTokenAPIError)
}


/* === 게시글 조회 === */
enum AttemptLookPost {
    case success(result: LookPostResponse)
    case commonError(error: CommonAPIError)
    case lookPostError(error: LookPostAPIError)
    case refreshTokenError(error: RefreshTokenAPIError)
}


/* === 게시글 삭제 === */



/* === 게시글 좋아요 === */
enum AttemptLikePost {
    case sucees(result: LikePostResponse)
    case commonError(error: CommonAPIError)
    case likePostError(error: LikePostAPIError)
    case refreshTokenError(error: RefreshTokenAPIError)
}



/* === 좋아요한 게시글 조회 === */
