//
//  DetailTourViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import Foundation
import RxSwift
import RxCocoa

class DetailTourViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    var wholeContentsViewModel: ContentsViewModel? = nil

    // 샘플 데이터. 화면 전환할 때 받을 예정
    var tourItem = Datum(
        likes: ["a", "b"],
        image: ["uploads/posts/1701840928977.jpeg", "uploads/posts/1701840929139.jpeg"],
        hashTags: ["자연", "문화", "역사"],
        comments: [],
        id: "65700821d3b44c277c358b38",
        creator: Creator(_id: "65700821d3b44c277c358b38", nick: "{\"nick\":\"닉네임 구조\",\"gender\":1,\"birthday\":\"19911128\",\"introduce\":\"안녕하세요. 닉네임 구조 새로 바꿔서 생년월일 성병 프로퍼티 빼고 닉네임 스트링에다 스트럭트로 다 때려박은 새로 가입한 계정. \\n으아아아아아아아\"}", profile: nil), 
        time: "2023-12-06T05:35:29.630Z",
        title: Optional("자연 역사 문화"),
        content: "{\"content\":\"ㅂㅂ\\n\\n\",\"hashTags\":\"#자연 #문화 #역사 \"}",
        dates: "{\"dates\":[\"20231220\",\"20231222\"]}",
        location: "{\"name\":\"청년취업사관학교 영등포캠퍼스\",\"longtitude\":126.886463,\"latitude\":37.517742}",
        maxPeopleCnt: Optional("2"),
        price: Optional("120000000000"),
        content5: Optional(""),
        productID: "sub_SeSAC"
    )
    
    
    
    
    struct Input {
        let applyButtonClicked: ControlEvent<Void>
        let goToProfileButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let resultApplyTour: PublishSubject<AttemptLikePost>
        
        let goToProfileButtonClicked: ControlEvent<Void>
    }
    
    
    func updateTourData(_ likeStatus: Bool) {
        
        if likeStatus {
            print("(DetailTourViewModel) - 여행 신청이기 때문에 배열에 유저 아이디 추가")
            if let userId = KeychainStorage.shared._id {
                tourItem.likes.append(userId)
            }
            
        } else {
            print("(DetailTourViewModel) - 여행 취소이기 때문에 배열에서 유저 아이디 삭제")
            tourItem.likes = tourItem.likes.filter { $0 != KeychainStorage.shared._id }
        }
        
        
        
    }
    
    func updateWholeTourData(_ likeStatus: Bool) {

        do {
            var values = try wholeContentsViewModel?.tourItems.value() ?? []
            
            
            // 1. 현재 투어 찾기
            for i in 0..<values.count {
                
                if values[i].id == tourItem.id {
                    print("전체 투어 아이템에서 디테일 투어의 아이템 찾았다")
                    
                    if likeStatus {
                        print("여행 신청이기 때문에 좋아요 배열에 유저 아이디 추가")
                        if let userId = KeychainStorage.shared._id {
                            values[i].likes.append(userId)
                        }
                        
                        print("추가 후 likes 배열 : \(values[i].likes)")
                    }
                    else {
                        print("여행 취소이기 때문에 좋아요 배열에서 유저 아이디 삭제")
                        
                        values[i].likes = values[i].likes.filter { $0 != KeychainStorage.shared._id}
                        
                        print("삭제 후 likes 배열 : \(values[i].likes)")
                    }
                }
            }
            
            wholeContentsViewModel?.tourItems.onNext(values)
            
        } catch {
            print("기존 화면의 데이터 가져오는 과정에서 try 에러")
            return
        }
    
        
    }
    
    func tranform(_ input: Input) -> Output {
        let resultApplyTour = PublishSubject<AttemptLikePost>()
        
        
        // 좋아요 기능 구현
        // (1). 네트워크 쏘기
        input.applyButtonClicked
            .flatMap {
                RouterAPIManager.shared.request(
                    type: LikePostResponse.self,
                    error: LikePostAPIError.self,
                    api: .likePost(
                        idStruct: LikePostRequest(
                            id: self.tourItem.id
                        )
                    )
                )
            }
            .map { [weak self] response in
                
                switch response {
                case .success(let result):
                    print("게시글 좋아요 성공")
                    
                    // (2). ContentsVC에서 물고있는 데이터 변경해주기
                    self?.updateWholeTourData(result.like_status)
                    
                    // (3). DetailVC에서 물고 있는 데이터도 변경해주기
                    self?.updateTourData(result.like_status)
                    
                    
                    
                    
                    return AttemptLikePost.sucees(result: result)
                    
                case .failure(let error):
                    print("게시글 좋아요 실패")
                    
                    // 1. 공통 에러 확인
                    if let commonError = error as? CommonAPIError {
                        print("(게시글 좋아요) 공통 에러")
                        return AttemptLikePost.commonError(error: commonError)
                    }
                    
                    // 2. 게시글 좋아요 에러
                    if let likePostError = error as? LikePostAPIError {
                        print("(게시글 좋아요) 게시글 좋아요 에러")
                        return AttemptLikePost.likePostError(error: likePostError)
                    }
                    
                    // 3. 토큰 관련 에러
                    if let refreshTokenError = error as? RefreshTokenAPIError {
                        print("(게시글 좋아요) 토큰 관련 에러")
                        return AttemptLikePost.refreshTokenError(error: refreshTokenError)
                    }
                    
                    // 4. 알 수 없는 에러
                    print("(게시글 좋아요) 알 수 없는 에러")
                    return AttemptLikePost.commonError(error: .unknownError)
                    
                }
            }
            .subscribe(with: self) { owner, value in
                resultApplyTour.onNext(value)
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            resultApplyTour: resultApplyTour,
            goToProfileButtonClicked: input.goToProfileButtonClicked
        )
        
    }
}


/*
 
 Optional(TravelWithMe.Datum(likes: [], image: ["uploads/posts/1701840928977.jpeg", "uploads/posts/1701840929139.jpeg"], hashTags: ["자연", "문화", "역사"], comments: [], id: "65700821d3b44c277c358b38", creator: TravelWithMe.Creator(_id: "65631a50d7032958655840e4", nick: "We"), time: "2023-12-06T05:35:29.630Z", title: Optional("자연 역사 문화"), content: "{\"content\":\"ㅂㅂ\\n\\n\",\"hashTags\":\"#자연 #문화 #역사 \"}", dates: "{\"dates\":[\"20231220\",\"20231222\"]}", location: "{\"name\":\"청년취업사관학교 영등포캠퍼스\",\"longtitude\":126.886463,\"latitude\":37.517742}", maxPeopleCnt: Optional("2"), price: Optional("0"), content5: Optional(""), productID: "sub_SeSAC"))
 뷰모델 데이터 : Optional(TravelWithMe.Datum(likes: [], image: ["uploads/posts/1701839787920.jpeg"], hashTags: ["도시", "자연", "문화"], comments: [], id: "657003aca165c727786105c2", creator: TravelWithMe.Creator(_id: "65631a50d7032958655840e4", nick: "We"), time: "2023-12-06T05:16:28.048Z", title: Optional("qq"), content: "{\"content\":\"qq\",\"hashTags\":\"#도시 #자연 #문화 \"}", dates: "{\"dates\":[\"20231213\",\"20231216\"]}", location: "{\"name\":\"청년취업사관학교 영등포캠퍼스\",\"longtitude\":126.886463,\"latitude\":37.517742}", maxPeopleCnt: Optional("3"), price: Optional("100"), content5: Optional(""), productID: "sub_SeSAC"))
 */
