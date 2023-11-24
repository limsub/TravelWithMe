//
//  MakeTourViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class MakeTourViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
    }
    
    func tranform(_ input: Input) -> Output {
        
        input.tap
            .flatMap { value in
                RouterAPIManager.shared.request(
                    type: MakePostResponse.self,
                    error: MakePostAPIError.self,
                    api: .makePost(sender: MakePostRequest(title: "테스트 타이틀", content: "테스트 컨텐츠", tourDates: "20231010", tourLocations: "위도, 경도", locationName: "새싹 영등포캠퍼스", maxPeopleCnt: "8", tourPrice: "30000"))
                )
            }
            .subscribe(with: self) { owner , value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        
        return Output(tap: input.tap)
    }
}
