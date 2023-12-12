//
//  MyTourViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import Foundation
import RxSwift
import RxCocoa

class MyTourViewModel: ViewModelType, TourItemsProtocol1 {


    let disposeBag = DisposeBag()
    
    var nextCursor = BehaviorSubject(value: "")
    
//    var tourItems: [Datum] = []
    
    
    var tourItems =  BehaviorSubject<[Datum]>(value: [])
    
    var userId: String  = ""
    

    struct Input {
        let a: String
        
        let itemSelected: ControlEvent<IndexPath>
    }

    struct Output {
        let myTourItems: BehaviorSubject<[Datum]>
        let resultLookPost: PublishSubject<AttemptLookPost>
        
        let itemSelected: ControlEvent<IndexPath>
        let nextTourInfo: PublishSubject<Datum>
    }
    
    func tranform(_ input: Input) -> Output {
        
//        let tourItems = BehaviorSubject<[Datum]>(value: [])
        let resultLookPost = PublishSubject<AttemptLookPost>()
        
        
        // 로그인을 했는데, 키체인에 id가 없을리가 없다. ok
        
        nextCursor
            .flatMap {
                RouterAPIManager.shared.request(
                    type: LookPostResponse.self ,
                    error: LookPostAPIError.self ,
                    api: .lookPost(
                        query: LookPostQueryString(next: $0, limit: "10"),
                        userId: self.userId
//                        likePost: true
                    )
                )
                
            }
            .map { response in
                switch response {
                    
                case .success(let result):
                    print("내 게시글 조회 성공")
                    return AttemptLookPost.success(result: result)
                case .failure(let error):
                    print("내 게시글 조회 실패")
                    
                    // 1. 공통 에러
                    if let commonError = error as? CommonAPIError {
                        print("- 공통 에러")
                        return AttemptLookPost.commonError(error: commonError)
                    }
                    
                    // 2. 게시글 조회 에러
                    if let lookPostError = error as? LookPostAPIError {
                        print("- 게시글 조회 에러")
                        return AttemptLookPost.lookPostError(error: lookPostError)
                    }
                    
                    // 3. 토큰 관련 에러
                    if let refreshTokenError = error as? RefreshTokenAPIError {
                        print("- 토큰 관련 에러")
                        return AttemptLookPost.refreshTokenError(error: refreshTokenError)
                    }
                    
                    // 4. 알 수 없음
                    print("- 알 수 없음")
                    return AttemptLookPost.commonError(error: .unknownError)
                }
            }
            .subscribe(with: self) { owner , value  in
                resultLookPost.onNext(value)
                
                if case AttemptLookPost.success(let result) = value {
//                    print("데이터 로딩에 성공했습니다. 배열 뒤에 추가합니다")
//                    print(result.data)
//                    owner.tourItems.append(contentsOf: result.data)
//                    print("배열 뒤에 추가 성공")
                    
                    print("데이터 로딩에 성공했습니다. 배열 뒤에 추가합니다")
                    var oldValues: [Datum] = []
                    do {
                        oldValues = try owner.tourItems.value()
                    } catch {
                        print("기존 배열을 가져오는 과정에서 오류 발생")
                    }
                    oldValues.append(contentsOf: result.data)

                    owner.tourItems.onNext(oldValues)
                    print("배열 뒤에 추가 성공")
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
            myTourItems: tourItems,
            resultLookPost: resultLookPost,
            itemSelected: input.itemSelected,
            nextTourInfo: nextTourInfo
        )
    }
    
    
    
    func deleteItem(_ result: DeletePostRespose) {
        
        let id = result.id
        
        do {
            var values = try tourItems.value()
            values = values.filter  { $0.id != id }
            tourItems.onNext(values)
            
        } catch {
            print("투어 아이템 에러 (do-catch)")
            return
        }
        
    }
}
