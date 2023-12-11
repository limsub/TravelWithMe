//
//  ModifyProfileViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/11/23.
//

import Foundation

class ModifyProfileViewModel: ViewModelType {
    
    // 이전 화면에서 값전달로 받아야 하는 프로필 데이터 -> 초기 뷰에 띄워준다
    var profileInfo: LookProfileResponse?
    
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    
    func tranform(_ input: Input) -> Output {
        return Output()
    }
}
