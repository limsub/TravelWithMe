//
//  SelectDateView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import FSCalendar

class SelectDateView: BaseView {
    
    var calendar = FSCalendar()
    let completeButton = SignUpCompleteButton("선택 완료")
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(calendar)
        addSubview(completeButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        calendar.snp.makeConstraints { make in
            make.size.equalTo(self.safeAreaLayoutGuide)
        }
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(45)
        }
    }
    
    override func setting() {
        super.setting()
        
        settingCalendar()
        
//        completeButton.addTarget(self , action: #selector(buttonClicked), for: .touchUpInside)
    }
    
 
    
    func settingCalendar() {
        calendar.appearance.titleSelectionColor = UIColor(hexCode: ConstantColor.Main1.hexCode)
        
        calendar.scrollDirection = .vertical
        
        calendar.allowsMultipleSelection = true
        
        
        
        
        print(calendar.selectedDates)
        
    }
    
}
