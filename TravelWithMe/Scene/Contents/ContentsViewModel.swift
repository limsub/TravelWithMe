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
        let searchCategory: BehaviorSubject<TourCategoryType>
    }
    struct Output {
        // 버튼 8개 고정 (전체 버튼 포함) -> MakeTour에서는 7개 (전체 x)
        let tourItems: BehaviorSubject<[Datum]>
        let resultLookPost: PublishSubject<AttemptLookPost>
    }
    
    func tranform(_ input: Input) -> Output {
        
        // 컬렉션뷰에 보여줄 데이터 배열
        let tourItems = BehaviorSubject<[Datum]>(value: [])
        
        // 네트워크 통신 결과
        let resultLookPost = PublishSubject<AttemptLookPost>()
        
        
        
        // 네트워크 통신을 하는 시점 :
            // 1. (input.searchCategory 변경) 다른 카테고리 버튼 클릭
            // 2. (nextCursor 변경) 페이지네이션 or 초기화
            // 다른 카테고리 버튼을 클릭하면 자동으로 nextCursor는 빈 문자열 넣어주기.
            // 즉, nextCursor가 변할 때만 네트워크 콜 bind
            // 이 때는 distinctUntilChanged 사용x (다른 카테고리로 검색 해야함)
        
        
        // 1. 다른 카테고리 버튼 클릭
        input.searchCategory
            .subscribe(with: self) { owner , value  in
                print("버튼 클릭 : ", value)
                
                owner.nextCursor.onNext("")
            }
            .disposed(by: disposeBag)
        
        // 2. nextCursor 변경
        nextCursor
            .flatMap {
                print("== 데이터 로딩 flatMap 실행")
                print("cursor : ", $0)
                print("hashTag : ", input.searchCategory)
                
                // input.searchCateogory 값 빼내오기
                let category: TourCategoryType
                do {
                    category = try input.searchCategory.value()
                } catch {
                    print("input.searchCategory 밸류 꺼내오기 실패. all로 저장")
                    category = .all
                }
                
                let hashTagText = category.searchText
                
                return RouterAPIManager.shared.request(
                    type: LookPostResponse.self,
                    error: LookPostAPIError.self ,
                    api: .lookPost(
                        query: LookPostQueryString(next: $0, limit: "10"),
                        userId: nil,    // 모든 유저가 올린 포스트에 대한 검색임
                        hashTag: hashTagText
                    )
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
                    
                    print("현재 nextCursor 값에 따라 배열을 통으로 바꿀지, 배열 뒤에 append 할지 결정합니다")
                    
                    var nextCursorText: String
                    do {
                        nextCursorText = try owner.nextCursor.value()
                    } catch {
                        print("nextCursor do try 에러. 빈 문자열로 처리")
                        nextCursorText = ""
                    }
                    
                    if (nextCursorText == "") {
                        print("-- nextCursor가 빈 문자열입니다.")
                        tourItems.onNext(result.data)
                        
                    } else {
                        print("-- nextCursor가 빈 문자열이 아닙니다.")
                        
                        var oldValues: [Datum] = []
                        do {
                            oldValues = try tourItems.value()
                        } catch {
                            print("기존 배열을 가져오는 과정에서 오류 발생. 빈 배열로 처리")
                        }
                        oldValues.append(contentsOf: result.data)

                        tourItems.onNext(oldValues)
                        print("배열 뒤에 추가하기 성공")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        
        
        
        // 페이지네이션 -> nextCursor 값 변경 (tmpNextCursor에 통신 결과로 받은 커서 값 저장)
        
        
        
        // 어떤 버튼이 눌렸는지 확인 후 해시태그 값 결정 (전체 이면 해시태그 nil)
        // -> 배열의 인덱스와 enum의 rawValue 동일
//        let hashTagText = Observable.zip(input.categoryButtons[0], input.categoryButtons[1], input.categoryButtons[2], input.categoryButtons[3], input.categoryButtons[4], input.categoryButtons[5], input.categoryButtons[6], input.categoryButtons[7]) { v1, v2, v3, v4, v5, v6, v7, v8 in
//            
//            let arr = [v1, v2, v3, v4, v5, v6, v7, v8]
//            print("해시태그 배열의 값 : ", arr)
//            for (index, element) in arr.enumerated() {
//                
//                // true인 카테고리 해시태그로 검색
//                if element {
//                    return TourCategoryType(rawValue: index)?.searchText
//                }
//            }
//            
//            return nil
//        }
        
//        let _ = input.categoryButton1.subscribe {
//            print("1Selected")
//        }
//        .disposed(by: disposeBag)
//        
//        
//        let hashTagText = Observable.zip(input.categoryButton2, input.categoryButton3, input.categoryButton4) {v2, v3, v4 in
//            
//            let arr = [v2, v3, v4]
//            print("해시태그 배열의 값 : ", arr)
//            for (index, element) in arr.enumerated() {
//                
//                // true인 카테고리 해시태그로 검색
//                if element {
//                    return TourCategoryType(rawValue: index)?.searchText
//                }
//            }
//            
//            return nil
//        }
//        
//        
//        let combineCursorAndHashTagButton = Observable.combineLatest(nextCursor, hashTagText)
//        
//        
//        // 데이터 로딩
//        combineCursorAndHashTagButton
//            .flatMap {
//                print("=== 데이터 로딩 flatmap 실행 ===")
//                print("cursur : ", $0.0)
//                print("hashTag : ", $0.1)
//                
//                return RouterAPIManager.shared.request(
//                    type: LookPostResponse.self,
//                    error: LookPostAPIError.self,
//                    api:
//                            
//                            /*.lookPost(query: LookPostQueryString(next: $0, limit: "10"), userId: KeychainStorage.shared._id)*/
//                            
//                            
//                            .lookPost(
//                                query: LookPostQueryString(
//                                    next: $0.0, limit: "10"),
//                                userId: nil,
//                                hashTag: $0.1
//                            )
//                        )
//            }
//            .map { response in
//                switch response {
//                case .success(let result):
//                    print("게시글 조회 성공")
//                    print(result)
//                    return  AttemptLookPost.success(result: result)
//                case .failure(let error):
//                    print("게시글 조회 실패")
//                    
//                    // 1. 공통 에러 확인
//                    if let commonError = error as? CommonAPIError {
//                        print(" - 공통 에러 중 하나")
//                        return AttemptLookPost.commonError(error: commonError)
//                    }
//                    
//                    // 2. 게시글 조회 에러
//                    if let lookPostError = error as? LookPostAPIError {
//                        print(" - 게시글 조회 에러 중 하나")
//                        return AttemptLookPost.lookPostError(error: lookPostError)
//                    }
//                    
//                    // 3. 토큰 관련 에러
//                    if let refreshTokenError = error as? RefreshTokenAPIError {
//                        print(" - 토큰 관련 에러 중 하나")
//                        return AttemptLookPost.refreshTokenError(error: refreshTokenError)
//                    }
//                    
//                    // 4. 알 수 없음
//                    print(" - 알 수 없는 에러")
//                    return AttemptLookPost.commonError(error: .unknownError)
//                }
//            }
//            .subscribe(with: self) { owner , value in
//                resultLookPost.onNext(value)
//                
//                if case AttemptLookPost.success(let result) = value {
//                    print("데이터 로딩에 성공했습니다. 배열 뒤에 추가합니다")
//                    
//                    var oldValues: [Datum] = []
//                    do {
//                        oldValues = try tourItems.value()
//                    } catch {
//                        print("기존 배열을 가져오는 과정에서 오류 발생")
//                    }
//                    oldValues.append(contentsOf: result.data)
//                    
//                    tourItems.onNext(oldValues)
//                    print("배열 뒤에 추가하기 성공")
//                }
//            }
//            .disposed(by: disposeBag)
        
        
        return Output(
            tourItems: tourItems,
            resultLookPost: resultLookPost
        )
    }
}
