//
//  Reactive+Extension.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit
import RxSwift
import RxCocoa

// 버튼의 isSelected 상태를 Observable<Bool> 로 받기

extension Reactive where Base: UIButton {
    
    var isSelected: ControlProperty<Bool> {
        
        return base.rx.controlProperty(
            editingEvents: [.touchUpInside]) { button  in
                button.isSelected
            } setter: { button , value  in
                print("value: \(value)")
                button.isSelected = value
            }

    }

}
