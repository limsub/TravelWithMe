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
        // 버튼.setTitle
        // 버튼.setImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        clipsToBounds = true
        layer.cornerRadius = 22
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexCode: ConstantColor.main1.hexCode).cgColor
        
//        backgroundColor = UIColor(hexCode: ConstantColor.main6.hexCode)
        
        setTitle("하이", for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
        
        setTitleColor(.black, for: .normal)
        
        setBackgroundColor(UIColor(hexCode: ConstantColor.main8.hexCode).withAlphaComponent(0.5), for: .normal)
        setBackgroundColor(UIColor(hexCode: ConstantColor.main3.hexCode), for: .selected)
    }
}
