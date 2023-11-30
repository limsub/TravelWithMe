//
//  ContentsViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa

class ContentsViewModel: ViewModelType {
    
    // 일단..?
    var nextCursor = BehaviorSubject<String>(value: "")
    
    let disposeBag = DisposeBag()
    
    
    struct Input {
        let a: String
    }
    struct Output {
        let tourItems: BehaviorSubject<[Datum]>
        let resultLookPost: PublishSubject<AttemptLookPost>
    }
    
    func tranform(_ input: Input) -> Output {
        
        let tourItems = BehaviorSubject<[Datum]>(value: [])
        
        let resultLookPost = PublishSubject<AttemptLookPost>()
        
        
        // 페이지네이션 -> nextCursor 값 변경 (tmpNextCursor에 통신 결과로 받은 커서 값 저장)
        
        
        // 데이터 로딩
        nextCursor
            .flatMap {
                RouterAPIManager.shared.request(
                    type: LookPostResponse.self,
                    error: LookPostAPIError.self,
                    api:
                            
                            /*.lookPost(query: LookPostQueryString(next: $0, limit: "10"), userId: KeychainStorage.shared._id)*/
                            
                            
                            .lookPost(query: LookPostQueryString(
                            next: $0, limit: "10"))
                        )
            }
            .map { response in
                switch response {
                case .success(let result):
                    print("게시글 조회 성공")
                    print(result)
                    return  AttemptLookPost.success(result: result)
                case .failure(let error):
                    print("게시글 조회 실패")
                    
                    // 1. 공통 에러 확인
                    if let commonError = error as? CommonAPIError {
                        print(" - 공통 에러 중 하나")
                        return AttemptLookPost.commonError(error: commonError)
                    }
                    
                    // 2. 게시글 조회 에러
                    if let lookPostError = error as? LookPostAPIError {
                        print(" - 게시글 조회 에러 중 하나")
                        return AttemptLookPost.lookPostError(error: lookPostError)
                    }
                    
                    // 3. 토큰 관련 에러
                    if let refreshTokenError = error as? RefreshTokenAPIError {
                        print(" - 토큰 관련 에러 중 하나")
                        return AttemptLookPost.refreshTokenError(error: refreshTokenError)
                    }
                    
                    // 4. 알 수 없음
                    print(" - 알 수 없는 에러")
                    return AttemptLookPost.commonError(error: .unknownError)
                }
            }
            .subscribe(with: self) { owner , value in
                resultLookPost.onNext(value)
                
                if case AttemptLookPost.success(let result) = value {
                    print("데이터 로딩에 성공했습니다. 배열 뒤에 추가합니다")
                    
                    var oldValues: [Datum] = []
                    do {
                        oldValues = try tourItems.value()
                    } catch {
                        print("기존 배열을 가져오는 과정에서 오류 발생")
                    }
                    oldValues.append(contentsOf: result.data)
                    
                    tourItems.onNext(oldValues)
                    print("배열 뒤에 추가하기 성공")
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            tourItems: tourItems,
            resultLookPost: resultLookPost
        )
    }
}
