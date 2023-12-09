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
    
    var selectedButtonIndex = BehaviorSubject<[Int]>(value: [])
    
    
    struct Input {
        let reviewTextViewText: ControlProperty<String>
        
        let completeButtonClicked: ControlEvent<Void>
    }
    struct Output {
        let enabledCompleteButton: Observable<Bool>
        let completeButtonClicked: ControlEvent<Void>
    }
    func tranform(_ input: Input) -> Output {
    
        
        let enabledCompleteButton = Observable.combineLatest(selectedButtonIndex, input.reviewTextViewText) { v1, v2 in
            
            return v1.count > 0 && !v2.isEmpty
        }
        
        
        return Output(
            enabledCompleteButton: enabledCompleteButton,
            completeButtonClicked: input.completeButtonClicked
        )
    }
}
