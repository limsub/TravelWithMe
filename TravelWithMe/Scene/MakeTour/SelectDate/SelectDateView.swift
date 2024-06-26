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

        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(52)
            make.horizontalEdges.equalTo(self).inset(18)
        }
        calendar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(completeButton.snp.top).inset(8)
        }
    }
    
    override func setting() {
        super.setting()
        
        settingCalendar()
    }
    
 
    
    func settingCalendar() {
        
        calendar.scrollDirection = .vertical
        calendar.allowsMultipleSelection = true
        
        calendar.register(SelectDatesCustomCalendarCell.self, forCellReuseIdentifier: SelectDatesCustomCalendarCell.description())
        
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 18)
        calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 20)
        
        calendar.today = nil
        calendar.appearance.selectionColor = .clear
        
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleSelectionColor = UIColor.appColor(.main1)
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        
    }
    
}
