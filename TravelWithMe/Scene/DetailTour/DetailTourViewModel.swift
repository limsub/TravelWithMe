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

    // 샘플 데이터. 화면 전환할 때 받을 예정
    var tourItem = Datum(
        likes: ["a", "b"],
        image: ["uploads/posts/1701840928977.jpeg", "uploads/posts/1701840929139.jpeg"],
        hashTags: ["자연", "문화", "역사"],
        comments: [],
        id: "65700821d3b44c277c358b38",
        creator: Creator(_id: "65700821d3b44c277c358b38", nick: "We"),
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
        let resultApplyTour: PublishSubject<Int>
        
        let goToProfileButtonClicked: ControlEvent<Void>
    }
    
    func tranform(_ input: Input) -> Output {
        let resultApplyTour = PublishSubject<Int>()
        
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
