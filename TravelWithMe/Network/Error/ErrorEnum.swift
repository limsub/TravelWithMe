//
//  ErrorEnum.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/22.
//

import Foundation

protocol APIError: RawRepresentable, Error where RawValue == Int {
    var description: String { get }
}

/* ===== 공통 에러 ===== */
enum CommonAPIError: Int, APIError {
    case invalidSeSACKey = 420
    case overInvocation = 429
    case invalidURL = 444
    case unknownError = 500
    
    var description: String {
        switch self {
        case .invalidSeSACKey:
            return "*공통 : SeSAC 키가 틀렸거나 없습니다"
        case .overInvocation:
            return "*공통 : 과호출입니다"
        case .invalidURL:
            return "*공통 : 비정상 URL입니다"
        case .unknownError:
            return "*공통 : 알 수 없는 에러입니다"
        }
    }
}


/* ===== 이메일 중복 확인 ===== */
enum ValidEmailAPIError: Int, APIError {
    case missingValue = 400
    case invalidEmail = 409
    
    var description: String {
        switch self {
        case .missingValue:
            return "필수값을 채워주세요"
        case .invalidEmail:
            return "사용이 불가한 이메일입니다"
        }
    }
}


/* ===== 회원가입 ===== */
enum JoinAPIError: Int, APIError {
    case missingValue = 400
    case alreadyRegistered = 409
    
    var description: String {
        switch self {
        case .missingValue:
            return "필수값을 채워주세요"
        case .alreadyRegistered:
            return "이미 가입된 유저입니다"
        }
    }
}


/* ===== 로그인 ===== */
enum LoginAPIError: Int, APIError {
    case missingValue = 400
    case inValidAccount = 401
    
    var description: String {
        switch self {
        case .missingValue:
            return "필수값을 채워주세요"
        case .inValidAccount:
            return "가입되지 않은 유저이거나, 비밀번호가 일치하지 않습니다"
        }
    }
}


/* ===== 토큰 갱신 ===== */
enum RefreshTokenAPIError: Int, APIError {
    case inValidToken = 401
    case forbidden = 403
    case notExpired = 409
    case refreshTokenExpired = 418
    
    var description: String {
        switch self {
        case .inValidToken:
            return "인증할 수 없는 액세스 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .notExpired:
            return "액세스 토큰이 만료되지 않았습니다"
        case .refreshTokenExpired:
            return "리프레시 토큰이 만료되었습니다"
        }
    }
}


/* ===== 게시글 작성 ===== */
enum MakePostAPIError: Int, APIError {
    case invalidRequest = 400
    case invalidToken = 401
    case forbidden = 403
    case postNotSaved = 410
    case tokenExpired = 419
    
    var description: String {
        switch self {
        case .invalidRequest:
            return "파일의 제한 사항과 맞지 않습니다"
        case .invalidToken:
            return "유효하지 않은 액세스 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .postNotSaved:
            return "서버 장애로 인해 게시글이 저장되지 않았습니다. 다시 시도해주세요"
        case .tokenExpired:
            return "액세스 토큰이 만료되었습니다"
        }
    }
}

/* ===== 게시글 조회 ===== */
enum LookPostAPIError: Int, APIError {
    case invalidRequest = 400
    case invalidToken = 401
    case forbidden = 403
    case tokenExpired = 419
    
    var description: String {
        switch self {
        default:
            return "하이하이하이하이"
        }
    }
}


/* ===== 게시글 삭제 ===== */
enum DeletePostAPIError: Int, APIError {
    case invalidToken = 401
    case forbidden = 403
    case postNotFound = 410
    case tokenExpired = 419
    case permissionDenied = 445
    
    var description: String {
        switch self {
        case .invalidToken:
            return "유효하지 않은 액세스 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .postNotFound:
            return "게시글을 찾을 수 없습니다"
        case .tokenExpired:
            return "액세스 토큰이 만료되었습니다"
        case .permissionDenied:
            return "게시글 삭제 권한이 없습니다. 본인이 작성한 게시글만 삭제할 수 있습니다"
        }
    }
}

/* ===== 게시글 좋아요 ===== */
enum LikePostAPIError: Int, APIError {
    case invalidToken = 401
    case forbidden = 403
    case postNotFound = 410
    case tokenExpired = 419
    
    var description: String {
        switch self {
        case .invalidToken:
            return "유효하지 않은 액세스 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .postNotFound:
            return "게시글을 찾을 수 없습니다"
        case .tokenExpired:
            return "액세스 토큰이 만료되었습니다"
        }
    }
}


/* ===== 프로필 조회 ===== */
enum LookProfileAPIError: Int, APIError {
    case invalidToken = 401
    case forbidden = 403
    case tokenExpired = 419
    
    var description: String {
        switch self {
        case .invalidToken:
            return "유효하지 않은 액세스 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .tokenExpired:
            return "액세스 토큰이 만료되었습니다"
        }
    }
}


/* ===== 프로필 수정 ===== */
enum ModifyMyProfileAPIError: Int, APIError {
    case invalidRequest = 400
    case invalidToken = 401
    case forbidden = 403
    case tokenExpired = 419
    
    var description: String {
        switch self {
        case .invalidRequest:
            return "파일의 제한 사항과 맞지 않습니다"
        case .invalidToken:
            return "유효하지 않은 액세스 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .tokenExpired:
            return "액세스 토큰이 만료되었습니다"
        }
    }
}

/* === 댓글 작성 === */
enum MakeReviewAPIError: Int, APIError {
    case invalidRequest = 400
    case invalidToken = 401
    case forbidden = 403
    case postNotFound = 410
    case tokenExpired = 419
    
    var description: String {
        switch self {
        case .invalidRequest:
            return "필수값이 누락되었습니다"
        case .invalidToken:
            return "유효하지 않은 액세스 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .postNotFound:
            return "게시글을 찾을 수 없습니다"
        case .tokenExpired:
            return "액세스 토큰이 만료되었습니다"
        }
    }
}


/* === 팔로우 === */
enum FollowAPIError: Int, APIError {
    case invalidRequest = 400
    case invalidToken = 401
    case forbidden = 403
    case alreadyFollowed = 409
    case postNotFound = 410
    case tokenExpired = 419
    
    var description: String {
        switch self {
        case .invalidRequest:
            return "필수값이 누락되었습니다"
        case .invalidToken:
            return "유효하지 않은 액세스 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .alreadyFollowed:
            return "이미 팔로우한 계정입니다"
        case .postNotFound:
            return "게시글을 찾을 수 없습니다"
        case .tokenExpired:
            return "액세스 토큰이 만료되었습니다"
        }
    }
}


/* === 언팔로우 === */
enum UnFollowAPIError: Int, APIError {
    case invalidRequest = 400
    case invalidToken = 401
    case forbidden = 403
    case postNotFound = 410
    case tokenExpired = 419
    
    var description: String {
        switch self {
        case .invalidRequest:
            return "필수값이 누락되었습니다"
        case .invalidToken:
            return "유효하지 않은 액세스 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .postNotFound:
            return "게시글을 찾을 수 없습니다"
        case .tokenExpired:
            return "액세스 토큰이 만료되었습니다"
        }
    }
    
}
