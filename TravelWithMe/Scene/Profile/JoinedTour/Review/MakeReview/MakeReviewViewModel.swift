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
    
    let disposeBag = DisposeBag()
    
    var selectedButtonCnt = 0
    
    struct Input {
        let reviewCategoryButtons: [ControlProperty<Bool>]  // 총 10개 들어옴.
        let completeButtonClicked: ControlEvent<Void>
    }
    struct Output {
//        let enabledCompleteButton: Observable<Bool>
        let completeButtonClicked: ControlEvent<Void>
    }
    func tranform(_ input: Input) -> Output {
    
        
//        let enabledCompleteButton = Observable.combineLatest(<#T##collection: Collection##Collection#>)
        
        return Output(
            completeButtonClicked: input.completeButtonClicked
        )
    }
}
