//
//  ErrorEnum.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/22.
//

import Foundation

//enum CommonAPIError: Error {
//    case networkError
//    case timeout
//    // 다른 공통된 API 에러들을 추가할 수 있습니다.
//}
//
//enum UserAPIError: Error {
//    case userNotFound
//    case unauthorized
//    // 다른 사용자 관련 API 에러들을 추가할 수 있습니다.
//}
//
//enum PostAPIError: Error {
//    case postNotFound
//    case permissionDenied
//    // 다른 포스트 관련 API 에러들을 추가할 수 있습니다.
//}
//
//// 각 API 엔드포인트에 대한 에러를 통합하는 Enum
//enum APIError {
//    case common(CommonAPIError)
//    case user(UserAPIError)
//    case post(PostAPIError)
//    // 다른 API 엔드포인트에 따른 에러들을 추가할 수 있습니다.
//}
//이제 API 엔드포인트에 따른 에러를 처리할 때, 해당 엔드포인트에 특화된 에러와 공통된 에러를 함께 다룰 수 있습니다.
//
//swift
//Copy code
//class NetworkService {
//    func request(endpoint: APIEndpoint, completion: @escaping (Result<Data, APIError>) -> Void) {
//        guard let url = URL(string: "https://api.example.com") else {
//            completion(.failure(.common(.networkError)))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: endpoint.url) { (data, response, error) in
//            guard error == nil else {
//                completion(.failure(.common(.networkError)))
//                return
//            }
//
//            guard let responseData = data else {
//                completion(.failure(.common(.timeout)))
//                return
//            }
//
//            do {
//                // 각 API 엔드포인트에 대한 디코딩 및 에러 처리를 분기합니다.
//                switch endpoint {
//                case .getUsers:
//                    // 사용자 API에 대한 디코딩 로직을 수행합니다.
//                    // ...
//
//                    // 예를 들어, 사용자를 찾을 수 없는 경우
//                    completion(.failure(.user(.userNotFound)))
//
//                case .getPosts:
//                    // 포스트 API에 대한 디코딩 로직을 수행합니다.
//                    // ...
//
//                    // 예를 들어, 포스트를 찾을 수 없는 경우
//                    completion(.failure(.post(.postNotFound)))
//                }
//
//            } catch {
//                completion(.failure(.common(.networkError)))
//            }
//        }
//
//        task.resume()
//    }
//}

//enum APIError {
//    case common(CommonAPIError)
//
//    case validEmail(ValidEmailAPIError)
//    case join(JoinAPIError)
//}

protocol APIError: RawRepresentable, Error where RawValue == Int {
    var description: String { get }
}

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
    case success = 200
    case missingValue = 400
    case inValidAccount = 401
    
    var description: String {
        switch self {
        case .success:
            return "로그인 성공"
        case .missingValue:
            return "필수값을 채워주세요"
        case .inValidAccount:
            return "가입되지 않은 유저이거나, 비밀번호가 일치하지 않습니다"
        }
    }
}
