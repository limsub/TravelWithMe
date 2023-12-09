//
//  ReviewCategoryButton.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit

class ReviewCategoryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    convenience init(_ reviewCategoryType: ReviewCategoryType) {
        self.init()
        
     
        setTitle(reviewCategoryType.rawValue, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = ButtonSelectedType.normal.borderColor.cgColor
        
        titleLabel?.font = .systemFont(ofSize: 12)
        
        setBackgroundColor(ButtonSelectedType.normal.backgroundColor, for: .normal)
        setBackgroundColor(ButtonSelectedType.selected.backgroundColor, for: .selected)
        
        setTitleColor(ButtonSelectedType.normal.textColor, for: .normal)
        setTitleColor(ButtonSelectedType.selected.textColor, for: .selected)
    }
    
    override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true:
                layer.borderColor = ButtonSelectedType.selected.borderColor.cgColor
            case false:
                layer.borderColor = ButtonSelectedType.normal.borderColor.cgColor
                
            }
        }
    }
}
