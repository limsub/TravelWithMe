//
//  MakeTourViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class MakeTourViewModel: ViewModelType {
    
    // "수정하기" 로 들어왔다면, 초기 데이터
    var initData: Datum?
    
    
    
    let disposeBag = DisposeBag()
    
    var tourImages: [Data] = []
    
    var tourPeopleCnt = BehaviorRelay(value: 0)
    var tourDates =  PublishSubject<TourDates>()
    var tourLocation =  PublishSubject<TourLocation>()
    
    
    struct Input {
        // 제목
        let titleText: ControlProperty<String>
        // 소개
        let contentText: ControlProperty<String>
        
        // 카테고리 선택 (무조건 7개 들어온다고 판단)
        // 0 ~ 6까지 인덱스로 판단. 인덱스는 enum의 RawValue와 일치
        let categoryButtons: [ControlProperty<Bool>]
        
        
        // 모집 인원 - 플러스, 마이너스 버튼에 따라 값 변경 (디폴트 0)
            // 실제 값은 viewModel의 데이터로 관리
        let peoplePlusTap: ControlEvent<Void>
        let peopleMinusTap: ControlEvent<Void>
        // 가격
        let priceText: ControlProperty<String>
        
        // 여행 일자, 장소 -> viewModel의 데이터로 관리
        
        // 완료 버튼 클릭
        let completeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let peopleCnt: BehaviorRelay<Int>
        let tap: ControlEvent<Void>
        let enabledCompleteButton: Observable<Bool>
        
        let resultCompleteButtonClicked: PublishSubject<AttemptPost>
    }
    
    
    func tranform(_ input: Input) -> Output {

        // 여행 제작 버튼 활성화
        let enabledCompleteButton = Observable.combineLatest(input.titleText, input.contentText, tourPeopleCnt, input.priceText, tourDates, tourLocation) { v1, v2, v3, v4, v5, v6 in
            
            let isImage = !self.tourImages.isEmpty
            
            print("-----------------")
            print(!v1.isEmpty, !v2.isEmpty, v3, !v4.isEmpty, !v5.dates.isEmpty, !v6.name.isEmpty, isImage)
            print("-----------------")
            
            return (!v1.isEmpty && !v2.isEmpty && v3 != 0
                    && !v4.isEmpty && !v5.dates.isEmpty && !v6.name.isEmpty && isImage)
        }
        
        
        // people Cnt Button 작동 (값 +, - 해주고 그 값을 다시 전달해서 뷰에 보일 수 있도록 한다)
        input.peoplePlusTap
            .subscribe(with: self) { owner , _ in
                print("plus tap")
                var cnt = owner.tourPeopleCnt.value
                cnt += 1;
                owner.tourPeopleCnt.accept(cnt)
            }
            .disposed(by: disposeBag)
        
        input.peopleMinusTap
            .subscribe(with: self) { owner , _ in
                print("minus tap")
                var cnt = owner.tourPeopleCnt.value
                if (cnt > 0) { cnt -= 1; }
                owner.tourPeopleCnt.accept(cnt)
            }
            .disposed(by: disposeBag)
        
        
        
        // 고려해야 할 것들
        // price Int로 바꾸고, ?? 0 으로 옵셔널 처리해주기
        // 모집 인원도 Int 형변환할게 없네. 걍 Int였구나
        
        
        // 투어 카테고리 -> 누른 버튼에 따라 #이름 조합으로 문자열 만들어주기
        let buttonsCombine = Observable.combineLatest(input.categoryButtons[0], input.categoryButtons[1], input.categoryButtons[2], input.categoryButtons[3], input.categoryButtons[4], input.categoryButtons[5], input.categoryButtons[6]) { v1, v2, v3, v4, v5, v6, v7 in
            
            var ansStr = ""
            var arr = [v1, v2, v3, v4, v5, v6, v7]
            for (index, element) in arr.enumerated() {
                if element {
                    // rawValue 0은 .all이니까 주의
                    
                    guard let newTxt = TourCategoryType(rawValue: index + 1)?.hashTagText else { continue }
                    
                    ansStr += newTxt
                }
            }
            
            return ansStr
        }
        
        buttonsCombine
            .subscribe(with: self) { owner , value in
                print("결과결과 : ", value)
            }
            .disposed(by: disposeBag)
        
        
        // 요청할 정보
        let makePostInfo = Observable.combineLatest(input.titleText, input.contentText, tourPeopleCnt, input.priceText, tourDates, tourLocation, buttonsCombine) { v1, v2, v3, v4, v5, v6, v7 in
            
            // content + category 를 합친 구조체를 문자열로 변환
            let newStruct = TourContent(content: v2, hashTags: v7)
            let newString = encodingStructToString(sender: newStruct)
            
            let price = Int(v4) ?? 0

            return (v1, newString ?? "", String(v3), String(price), v5, v6)
        }
        
        let resultCompleteButtonClicked = PublishSubject<AttemptPost>()
        
        input.completeButtonClicked
            .withLatestFrom(makePostInfo)
            .flatMap { value in
                
                let tourDatesString = encodingStructToString(sender: value.4) ?? ""
                let tourLocationString = encodingStructToString(sender: value.5) ?? ""
                
                // 게시글 작성 or 게시글 수정 (initData의 유무로 분기)
                if self.initData == nil {
                    // 게시글 작성
                    return RouterAPIManager.shared.requestMultiPart(
                        type: MakePostResponse.self,
                        error: MakePostAPIError.self,
                        api: .makePost(
                            sender: MakePostRequest(title: value.0, content: value.1, file: self.tourImages, tourDates: tourDatesString, tourLocations: tourLocationString, maxPeopleCnt: value.2, tourPrice: value.3)
                        )
                    )
                    
                } else {
                    // 게시글 수정
                    return RouterAPIManager.shared.requestMultiPart(
                        type: MakePostResponse.self,
                        error: ModifyPostAPIError.self,
                        api: .modifyPost(
                            sender: MakePostRequest(title: value.0, content: value.1, file: self.tourImages, tourDates: tourDatesString, tourLocations: tourLocationString, maxPeopleCnt: value.2, tourPrice: value.3),
                            poseID: self.initData!.id
                        ))
                }
                
                
            }
            .map { response in
                    switch response {
                    case .success(let result):
                        print("게시글 작성/수정 성공")
                        return AttemptPost.success(result: result)
                    case .failure(let error):
                        print("게시글 작성/수정 실퍠")
                        
                        if let commonError = error as? CommonAPIError {
                            print("  공통 에러 중 하나")
                            return AttemptPost.commonError(error: commonError)
                        }
                        
                        if let makePostError = error as? MakePostAPIError {
                            print("  게시글 작성 에러 중 하나")
                            return AttemptPost.makePostError(error: makePostError)
                        }
                        
                        if let modifyPostError = error as? ModifyPostAPIError {
                            print("  게시글 수정 에러 중 하나")
                            return AttemptPost.modifyPostError(error: modifyPostError)
                        }
                        
                        if let expiredTokenError = error as? RefreshTokenAPIError {
                            print ("  토큰 만료 에러 중 하나")
                            return AttemptPost.refreshTokenError(error: expiredTokenError)
                        }
                        
                        print("  알 수 없는 에러.. 뭔 에러일까..?")
                        return AttemptPost.commonError(error: .unknownError)
                        
                    }

            }
            .subscribe(with: self) { owner , value in
                resultCompleteButtonClicked.onNext(value)
            }
            .disposed(by: disposeBag)

        
        
        return Output(
            peopleCnt: tourPeopleCnt,
            tap: input.completeButtonClicked,
            enabledCompleteButton: enabledCompleteButton,
            resultCompleteButtonClicked: resultCompleteButtonClicked
        )
    }
}
