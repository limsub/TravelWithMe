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
 즉, rx + Input/Output으로 구현한 뷰에 대해서만 적용
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





/* === 게시글 작성 + 게시글 수정 === */
enum AttemptPost {
    case success(result: MakePostResponse)
    case commonError(error: CommonAPIError)
    case makePostError(error: MakePostAPIError)
    case modifyPostError(error: ModifyPostAPIError)
    case refreshTokenError(error: RefreshTokenAPIError)
}




/* === 게시글 조회 === *//* === 좋아요한 게시글 조회 === */
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


/* === 프로필 조회 === */
enum AttemptLookProfile {
    case success(result: LookProfileResponse)
    case commonError(error: CommonAPIError)
    case lookProfileError(error: LookProfileAPIError)
    case refreshTokenError(error: RefreshTokenAPIError)
}

/* === 내 프로필 수정 === */
enum AttemptModifyMyProfile {
    case success(result: LookProfileResponse)   // 프로필 조회와 같은 응답 형식
    case commonError(error: CommonAPIError)
    case modifyMyProfileError(error: ModifyMyProfileAPIError)
    case refreshTokenError(error: RefreshTokenAPIError)
}


/* === 댓글 작성 === */ /* === 댓글 수정 === */
enum AttemptReview {
    case success(result: Comment)   // 타입이 동일하기 때문에 편의를 위해 Comment 타입으로 받는다
    case commonError(error: CommonAPIError)
    case makeReviewError(error: MakeReviewAPIError)
    case modifyReviewError(error: ModifyReviewAPIError)
    case refreshTokenError(error: RefreshTokenAPIError)
}

