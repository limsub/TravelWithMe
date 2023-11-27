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
    
    let disposeBag = DisposeBag()
    
//    var tourImages: [UIImage] = []
    var tourImages: [Data] = []
    
    var tourPeopleCnt = BehaviorRelay(value: 0)
    var tourDates =  PublishSubject<TourDates>()
    var tourLocation =  PublishSubject<TourLocation>()
    
    
    struct Input {
        // 제목
        let titleText: ControlProperty<String>
        // 소개
        let contentText: ControlProperty<String>
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
        
        let resultCompleteButtonClicked: PublishSubject<AttemptMakePost>
    }
    
    func tranform(_ input: Input) -> Output {
        
//        tourImages[0].jpegData(compressionQuality: 1)
        
        // 여행 제작 버튼 활성화
        let enabledCompleteButton = Observable.combineLatest(input.titleText, input.contentText, tourPeopleCnt, input.priceText, tourDates, tourLocation) { v1, v2, v3, v4, v5, v6 in
            
            let isImage = !self.tourImages.isEmpty
            
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
        
        // 요청할 정보
        let makePostInfo = Observable.combineLatest(input.titleText, input.contentText, tourPeopleCnt, input.priceText, tourDates, tourLocation) { v1, v2, v3, v4, v5, v6 in
            let price = Int(v4) ?? 0

            return (v1, v2, String(v3), String(price), v5, v6)
        }
        
        let resultCompleteButtonClicked = PublishSubject<AttemptMakePost>()
        
        input.completeButtonClicked
            .withLatestFrom(makePostInfo)
            .flatMap { value in
                
                let tourDatesString = encodingStructToString(sender: value.4) ?? ""
                let tourLocationString = encodingStructToString(sender: value.5) ?? ""
                return RouterAPIManager.shared.requestMultiPart(
                    type: MakePostResponse.self,
                    error: MakePostAPIError.self,
                    api: .makePost(
                        sender: MakePostRequest(title: value.0, content: value.1, file: self.tourImages, tourDates: tourDatesString, tourLocations: tourLocationString, maxPeopleCnt: value.2, tourPrice: value.3)
                    )
                )
            }
            .map { response in
                switch response {
                case .success(let result):
                    print("게시글 작성 성공")
                    return AttemptMakePost.success(result: result)
                case .failure(let error):
                    print("게시글 작성 실퍠")
                    
                    if let commonError = error as? CommonAPIError {
                        print("  공통 에러 중 하나")
                        return AttemptMakePost.commonError(error: commonError)
                    }
                    
                    if let makePostError = error as? MakePostAPIError {
                        print("  게시글 작성 에러 중 하나")
                        return AttemptMakePost.makePostError(error: makePostError)
                    }
                    
                    if let expiredTokenError = error as? RefreshTokenAPIError {
                        print ("  토큰 만료 에러 중 하나")
                        print("  만약 에러 내용이 '리프레시 토큰 만료'이면 로그인 화면으로 돌아가야 합니다")
                        return AttemptMakePost.refreshTokenError(error: expiredTokenError)
                    }
                    
                    print("  알 수 없는 에러.. 뭔 에러일까..?")
                    return AttemptMakePost.commonError(error: .unknownError)
                
                }
            }
            .subscribe(with: self) { owner , value in
                resultCompleteButtonClicked.onNext(value)
            }
            .disposed(by: disposeBag)
        
        // 날짜, 위치 테스트 (VC에서 VM의 데이터에 onNext로 넣어줌) (transform이랑 관련 x)
        tourDates
            .subscribe(with: self) { owner , value in
                print("날짜 테스트중 : ", value)
            }
            .disposed(by: disposeBag)
        tourLocation
            .subscribe(with: self) { owner , value in
                print("위치 테스트중 : ", value)
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
