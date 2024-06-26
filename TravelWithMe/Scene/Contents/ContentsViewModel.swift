//
//  ContentsViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa

class ContentsViewModel: ViewModelType, TourItemsProtocol1 {
    
    // 일단..?
    var nextCursor = BehaviorSubject<String>(value: "")
    
    
    /* 네트워크 통신 결과를 저장 */
    // 컬렉션뷰에 보여줄 데이터 배열
    var tourItems = BehaviorSubject<[Datum]>(value: [])
    // 다음 페이지네이션에서 사용할 nextCursor
    var nextCursorItem: String = ""
    
    
    let disposeBag = DisposeBag()
    
    
    struct Input {
        let searchCategory: BehaviorSubject<TourCategoryType>
        
        let itemSelected: ControlEvent<IndexPath>
        let prefetchItem: ControlEvent<[IndexPath]>
        let refreshControlValueChanged: ControlEvent<Void>
    }
    struct Output {
        // 버튼 8개 고정 (전체 버튼 포함) -> MakeTour에서는 7개 (전체 x)
        let tourItems: BehaviorSubject<[Datum]>
        let resultLookPost: PublishSubject<AttemptLookPost>
        
        let itemSelected: ControlEvent<IndexPath>
        let nextTourInfo: PublishSubject<Datum>
        
        let refreshLoading: BehaviorSubject<Bool>
    }
    
    func tranform(_ input: Input) -> Output {
        
        
        // refreshControl
        let refreshLoading = BehaviorSubject<Bool>(value: false)
        input.refreshControlValueChanged
            .subscribe(with: self) { owner , value in
                print("새로고침")
                refreshLoading.onNext(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    owner.nextCursor.onNext("")
                    refreshLoading.onNext(false)
                }
            }
            .disposed(by: disposeBag)

        // pagination
        input.prefetchItem
            .subscribe(with: self) { owner , value in
                do {
                    let tourItemsCnt = try owner.tourItems.value().count
                    
                    if value.contains(where: { $0.row == tourItemsCnt - 2 }) {
                        // pagination 실행
                        if owner.nextCursorItem != "0" {
                            owner.nextCursor.onNext(owner.nextCursorItem)
                        }
                    }
                } catch {
                    print("에러났슈")
                }
            }
            .disposed(by: disposeBag)

        
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
                // 커서 초기화 -> 첫번째 페이지로 네트워크 재요청
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
//                    print(result)
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
                    print("데이터 로딩에 성공했습니다.")
                    owner.nextCursorItem = result.nextCursor
                    
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
                        owner.tourItems.onNext(result.data)
                        
                    } else {
                        print("-- nextCursor가 빈 문자열이 아닙니다.")
                        
                        var oldValues: [Datum] = []
                        do {
                            oldValues = try owner.tourItems.value()
                        } catch {
                            print("기존 배열을 가져오는 과정에서 오류 발생. 빈 배열로 처리")
                        }
                        oldValues.append(contentsOf: result.data)

                        owner.tourItems.onNext(oldValues)
                        print("배열 뒤에 추가하기 성공")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        
        // 다음 화면으로 넘겨줘야 하는 투어 정보
        let nextTourInfo = PublishSubject<Datum>()
                
        input.itemSelected
            .withLatestFrom(tourItems) { v1, v2 in
                return (v1, v2)
            }
            .subscribe(with: self) { owner , value in
                nextTourInfo.onNext(value.1[value.0.item])
            }
            .disposed(by: disposeBag)
        
        return Output(
            tourItems: tourItems,
            resultLookPost: resultLookPost,
            itemSelected: input.itemSelected,
            nextTourInfo: nextTourInfo,
            refreshLoading: refreshLoading
        )
    }
}
