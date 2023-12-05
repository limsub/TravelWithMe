//
//  SelectDateViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import FSCalendar

@objc
protocol SecondViewControllerDelegate {
    @objc optional func printDates(value: [String])
}


class SelectDateViewController: BaseViewController {
    
    let mainView = SelectDateView()
    
    var delegate: SelectTourDatesDelegate?
    
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date] = []
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.completeButton.addTarget(self , action: #selector(completeButtonClicked), for: .touchUpInside)
        
        settingCalendar()
    }
    
    func settingCalendar() {
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
    }
    
    
    
    @objc
    func completeButtonClicked() {
        
        // 선택 날짜가 하나
        if datesRange.count == 1 {
            delegate?.sendDates?(value: [datesRange.first!.toString(of: .full) ])
        }
        // 선택 날짜가 여러개 -> 첫째날 마지막날 전달
        else {
            let firstDate = datesRange.first!.toString(of: .full)
            let lastDate = datesRange.last!.toString(of: .full)
            
            delegate?.sendDates?(value: [firstDate, lastDate])
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension SelectDateViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 모두 초기화
        let arr = datesRange
        
        if !arr.isEmpty {
            for day in arr {
                calendar.deselect(day)
            }
        }
        firstDate = nil
        lastDate = nil
        datesRange = []
        
        mainView.calendar.reloadData()
        checkButtonEnabled()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print("selected : \(date) -- \(typeOfDate(date))")
        
        // 1. 아무것도 선택되지 않은 경우 -> firstDate 설정
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            
            mainView.calendar.reloadData()
            checkButtonEnabled()
            return
        }
        
        // 2. firstDate만 선택된 경우
        if firstDate != nil && lastDate == nil {
            // firstDate 이전 날짜 선택 -> firstDate 변경
            if date < firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                
                mainView.calendar.reloadData()
                checkButtonEnabled()
                return
            }
            
            // firstDate 이후 날짜 선택 -> 범위 선택
            else {
                var range: [Date] = []
                
                var currentDate = firstDate!
                while currentDate <= date {
                    range.append(currentDate)
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                }
                
                for day in range {
                    calendar.select(day)
                }
                
                lastDate = range.last
                datesRange = range
                
                mainView.calendar.reloadData()
                checkButtonEnabled()
                return
            }
        }
        
        // 3. 두 개가 모두 선택되어 있는 상태
        if firstDate != nil && lastDate != nil {
            print(calendar.selectedDates)
            for day in calendar.selectedDates {
                calendar.deselect(day)
            }
            
            lastDate = nil
            
            firstDate = date
            calendar.select(date)
            datesRange = [firstDate!]
                
            mainView.calendar.reloadData()
            checkButtonEnabled()
            return
        }
        
        
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: SelectDatesCustomCalendarCell.description(), for: date, at: position) as? SelectDatesCustomCalendarCell else { return FSCalendarCell() }
        
        print("cell 다시 그리기 - \(date) - \(typeOfDate(date))")
        cell.updateBackImage(typeOfDate(date))
        
        return cell
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

}


extension SelectDateViewController {
    
    // date가 first, middle, last, notselect 중 무엇인지 리턴한다
    func typeOfDate(_ date: Date) -> SelectedDateType {
        
        let arr = datesRange
        
        if !arr.contains(date) {
            return .notSelectd
        }
        
        else {
            if arr.count == 1 && date == firstDate { return .singleDate }
            
            if date == firstDate { return .firstDate }
            if date == lastDate { return .lastDate }
            
            else { return .middleDate }
        }
    }
    
    // 현재 날짜 선택 유무에 따라 버튼 enabled 교체
    func checkButtonEnabled() {
        
        if !datesRange.isEmpty {
            mainView.completeButton.update(.enabled)
            
        } else {
            mainView.completeButton.update(.disabled)
        }
    }
}
