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
    
    // "수정하기" 로 들어왔다면,
    var initData: Comment? // 초기 데이터
    var checkReviewData: CheckReviewViewModel? // 이전 화면 (CheckReview)의 데이터
    
    
    // 값전달로 받는 투어 정보
    var tourItem: Datum?
    
    
    let disposeBag = DisposeBag()
    
    var selectedButtonCnt = 0
    
    var selectedButtonIndex = BehaviorSubject<[Int]>(value: [])
    
    
    
    func updateCheckReviewData(_ newComment: Comment) {
        
        if checkReviewData == nil { return }
        if checkReviewData?.tourItem == nil { return }
        
        // 1. 현재 내가 수정한 댓글 찾기
        for (index, item) in checkReviewData!.tourItem!.comments.enumerated() {
            
            if item._id == initData?._id {
                print("리뷰 확인 창의 리뷰들 중 수정한 리뷰를 찾았다.")
                
                // 2. 기존 댓글 대신 내가 수정한 댓글로 넣어주기
                checkReviewData?.tourItem?.comments[index] = newComment
            }
        }
    }
    
    
    struct Input {
        let reviewTextViewText: ControlProperty<String>
        
        let completeButtonClicked: ControlEvent<Void>
    }
    struct Output {
        let enabledCompleteButton: Observable<Bool>
        let completeButtonClicked: ControlEvent<Void>
        
        let resultCompleteButtonClicked: PublishSubject<AttemptReview>
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
        
        let resultCompleteButtonClicked = PublishSubject<AttemptReview>()
        
        input.completeButtonClicked
            .withLatestFrom(reviewContentString)
            .flatMap { value in
                
                // 편의를 위해! MakeReviewResponse가 아니라 Comment 타입으로 응답값을 받자
                if self.initData == nil {
                    // 후기 작성
                    
                    return RouterAPIManager.shared.request(
                        type: Comment.self,
                        error: MakeReviewAPIError.self,
                        api: .makeReview(
                            sender: MakeReviewRequest(content: value),
                            postID: self.tourItem?.id ?? ""
                        ))
                } else {
                    // 후기 수정
                    
                    return RouterAPIManager.shared.request(
                        type: Comment.self,
                        error: ModifyReviewAPIError.self,
                        api: .modifyReview(
                            sender: MakeReviewRequest(content: value),
                            postID: self.tourItem?.id ?? "",
                            commentID: self.initData?._id ?? ""
                        ))
                }
            }
            .map { response in
                switch response {
                case .success(let result):
                    print("댓글 작성/수정 성공")
                    
                    // 댓글 수정인 경우, 이전 뷰모델의 데이터를 직접 수정해준다
                    if self.initData != nil {
                        print("댓글 수정 성공이기 때문에 '후기 확인' 화면의 뷰모델에 직접 접근 후 데이터 변경")
                        self.updateCheckReviewData(result)
                    }
                    
                    return AttemptReview.success(result: result)
                    
                case .failure(let error):
                    print("댓글 작성/수정 실패")
                    
                    if let commonError = error as? CommonAPIError {
                        print("  공통 에러 중 하나")
                        return AttemptReview.commonError(error: commonError)
                    }
                    
                    if let makeReviewError = error as? MakeReviewAPIError {
                        print("  댓글 작성 에러 중 하나")
                        return AttemptReview.makeReviewError(error: makeReviewError)
                    }
                    
                    if let modifyReviewError = error as? ModifyReviewAPIError {
                        print("  댓글 수정 에러 중 하나")
                        return AttemptReview.modifyReviewError(error: modifyReviewError)
                    }
                    
                    if let expiredTokenError = error as? RefreshTokenAPIError {
                        print ("  토큰 만료 에러 중 하나")
                        return AttemptReview.refreshTokenError(error: expiredTokenError)
                    }
                    
                    print("  알 수 없는 에러.. 뭔 에러일까..?")
                    return AttemptReview.commonError(error: .unknownError)
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
