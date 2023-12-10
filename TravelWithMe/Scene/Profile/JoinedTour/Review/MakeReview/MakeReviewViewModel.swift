//
//  MakeReviewViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import Foundation
import RxSwift
import RxCocoa

class MakeReviewViewModel: ViewModelType {
    
    
    // 리뷰 성공 시 이전 화면 item reload를 위한 indexPath
    var tourItemIndexPath = IndexPath(row: 0, section: 0)
    
    // 값전달로 받는 투어 정보
    var tourItem: Datum?
    
    
    let disposeBag = DisposeBag()
    
    var selectedButtonCnt = 0
    
    var selectedButtonIndex = BehaviorSubject<[Int]>(value: [])
    
    
    
    
    
    
    struct Input {
        let reviewTextViewText: ControlProperty<String>
        
        let completeButtonClicked: ControlEvent<Void>
    }
    struct Output {
        let enabledCompleteButton: Observable<Bool>
        let completeButtonClicked: ControlEvent<Void>
        
        let resultCompleteButtonClicked: PublishSubject<AttempMakeReview>
    }
    func tranform(_ input: Input) -> Output {
    
        
        let enabledCompleteButton = Observable.combineLatest(selectedButtonIndex, input.reviewTextViewText) { v1, v2 in
            return v1.count > 0 && !v2.isEmpty
        }
        
        let reviewContentString = Observable.combineLatest(selectedButtonIndex, input.reviewTextViewText) { v1, v2 in
            
            let reviewContentStruct = ReviewContent(
                categoryArr: v1,
                content: v2
            )
            return encodingStructToString(sender: reviewContentStruct) ?? ""
        }
        
        let resultCompleteButtonClicked = PublishSubject<AttempMakeReview>()
        
        input.completeButtonClicked
            .withLatestFrom(reviewContentString)
            .flatMap { value in
                
                print("필수값 : \(value)")
                return RouterAPIManager.shared.request(
                    type: MakeReviewResponse.self,
                    error: MakeReviewAPIError.self,
                    api: .makeReview(
                        sender: MakeReviewRequest(content: value),
                        postID: self.tourItem?.id ?? ""
                    )
                )
                
            }
            .map { response in
                switch response {
                case .success(let result):
                    print("댓글 작성 성공")
                    return AttempMakeReview.success(result: result)
                    
                case .failure(let error):
                    print("댓글 작성 실패")
                    
                    if let commonError = error as? CommonAPIError {
                        print("  공통 에러 중 하나")
                        return AttempMakeReview.commonError(error: commonError)
                    }
                    
                    if let makeReviewError = error as? MakeReviewAPIError {
                        print("  댓글 작성 에러 중 하나")
                        return AttempMakeReview.makeReviewError(error: makeReviewError)
                    }
                    
                    if let expiredTokenError = error as? RefreshTokenAPIError {
                        print ("  토큰 만료 에러 중 하나")
                        print("  만약 에러 내용이 '리프레시 토큰 만료'이면 로그인 화면으로 돌아가야 합니다")
                        return AttempMakeReview.refreshTokenError(error: expiredTokenError)
                    }
                    
                    print("  알 수 없는 에러.. 뭔 에러일까..?")
                    return AttempMakeReview.commonError(error: .unknownError)
                }
                
                
            }
            .subscribe(with: self) { owner , value in
                resultCompleteButtonClicked.onNext(value)
            }
            .disposed(by: disposeBag)
        

        return Output(
            enabledCompleteButton: enabledCompleteButton,
            completeButtonClicked: input.completeButtonClicked,
            resultCompleteButtonClicked: resultCompleteButtonClicked
        )
    }
}
