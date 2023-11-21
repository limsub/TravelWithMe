//
//  BaseViewModelType.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/21.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    
    func tranform(_ input: Input) -> Output
}
