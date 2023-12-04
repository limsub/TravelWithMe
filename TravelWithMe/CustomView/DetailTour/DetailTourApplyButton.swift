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
//        setTitleColor(UIColor.appColor(.disabledGray1), for: .normal)
//        backgroundColor = UIColor.appColor(.disabledGray2)
        
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.appColor(.main1)
        
        
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        clipsToBounds = true
        layer.cornerRadius = 10
        
        setTitle("신청하기 1/3", for: .normal)
    }
}
