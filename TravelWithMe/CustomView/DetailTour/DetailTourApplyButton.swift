//
//  DetailTourApplyButton.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit

class DetailTourApplyButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        
        update(.disabled)
        
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        clipsToBounds = true
        layer.cornerRadius = 10
        
        setTitle("신청하기 1/3", for: .normal)
    }
    
    func updateButton(_ likesCnt: Int, maxCnt: Int, isMine: Bool, isApplied: Bool, outOfDates: Bool) {
        
        var buttonType: ApplyButtonType
        
        // 1. 내가 만든 투어인지
        if isMine { 
            buttonType = .myTour(likes: likesCnt, max: maxCnt)
        }
//        // 1.5 이미 기한이 지난 투어인지!
//        else if outOfDates {
//            buttonType = .outOfDate(likes: likesCnt, max: maxCnt)
//        }
        // 2. 내가 신청한 투어인지
        else if isApplied {
            buttonType = .applied(likes: likesCnt, max: maxCnt)
        }
        // 3. 신청이 가능한 투어인지 (마감 여부)
        else if likesCnt < maxCnt {
            buttonType = .unApplied(likes: likesCnt, max: maxCnt)
        }
        // 4. 이미 마감된 투어인지
        else if likesCnt == maxCnt {
            buttonType = .closed(max: maxCnt)
        }
        // 5. 몰라 이건
        else {
            buttonType = .closed(max: 0)
        }
        
        setTitle(buttonType.buttonTitle, for: .normal)
        update(buttonType.buttonEnabled)
        
        // 예외적으로, 내가 만든 투어인 경우에는 배경색은 살려주지만, 버튼 enabled는 꺼줘야 한다
        if isMine { isEnabled = false }
    }
    
    func update(_ state: ButtonEnabledType) {
        self.isEnabled = state.isEnabled
        backgroundColor = state.backgroundColor
        setTitleColor(state.textColor, for: .normal)
    }
    
    
}
