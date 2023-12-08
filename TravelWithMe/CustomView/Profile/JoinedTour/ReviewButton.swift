//
//  ReviewButton.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/8/23.
//

import UIKit
import SnapKit

class ReviewButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        clipsToBounds = true
        layer.cornerRadius = 20
        
        update(.writeReview)
    }
    
    func update(_ sender: ReviewButtonType) {
        setTitle(sender.buttonTitle, for: .normal)
        setTitleColor(sender.textColor, for: .normal)
        setBackgroundColor(sender.backgroundColor, for: .normal)
        isEnabled = sender.isEnabled
    }
    
}
