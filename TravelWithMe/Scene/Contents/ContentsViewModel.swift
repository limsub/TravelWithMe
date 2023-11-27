//
//  ContentsViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa

class ContentsViewModel: ViewModelType {
    
    
    struct Input {
        let a: String
    }
    struct Output {
        let sampleItems: BehaviorSubject<[String]>
    }
    
    func tranform(_ input: Input) -> Output {
        
        let sampleItem = BehaviorSubject<[String]>(value: [])
        
        sampleItem
            .onNext([
                "as",
                "as",
                "as",
                "as",
                "as",
                "as",
                "as",
            ])
        
        
        print("트랜스폼")
        print(sampleItem.values)
        
        
        return Output(
            sampleItems: sampleItem
        )
    }
}
