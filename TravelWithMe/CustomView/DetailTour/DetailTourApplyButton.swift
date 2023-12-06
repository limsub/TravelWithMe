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
    
    func updateCnt(_ likesCnt: Int, maxCnt: Int) {
        
        // 그럴 일은 없겠지만..
        if likesCnt > maxCnt {
            update(.disabled)
            setTitle("마감 \(maxCnt)/\(maxCnt)", for: .normal)
        }
        else if likesCnt == maxCnt {
            update(.disabled)
            setTitle("마감 \(likesCnt)/\(maxCnt)", for: .normal)
        } else {
            update(.enabled)
            setTitle("신청하기 \(likesCnt)/\(maxCnt)", for: .normal)
        }
    }
    
    func update(_ state: ButtonEnabledType) {
        self.isEnabled = state.isEnabled
        backgroundColor = state.backgroundColor
        setTitleColor(state.textColor, for: .normal)
    }
    
    
}
