//
//  ContentsCategoryButton.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/28.
//

import UIKit


class ContentsCategoryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    convenience init(_ tourCategoryType: TourCategoryType) {
        self.init()
        
        setUp()
        
        setTitle(tourCategoryType.buttonTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 1
        
        layer.borderColor = ButtonSelectedType.normal.borderColor.cgColor
        
        titleLabel?.font = .systemFont(ofSize: 14)
        
//        backgroundColor = ButtonSelectedType.normal.backgroundColor
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
