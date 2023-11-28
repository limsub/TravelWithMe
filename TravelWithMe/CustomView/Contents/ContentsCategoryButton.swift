//
//  ContentsCategoryButton.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/28.
//

import UIKit

enum CategoryType: String {
    case all = "  전체  "
    case city = "  도시  "
    case nature = "  자연  "
    case culture = "  문화  "
    case food = "  음식  "
    case adventure = "  모험  "
    case history = "  역사  "
    case local = "  로컬  "
}


class ContentsCategoryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    convenience init(_ tourCategoryType: CategoryType) {
        self.init()
        
        setTitle(tourCategoryType.rawValue, for: .normal)
        // 버튼.setTitle
        // 버튼.setImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexCode: ConstantColor.main2.hexCode).cgColor
        
        backgroundColor = UIColor(hexCode: ConstantColor.main6.hexCode)
        
        setTitle("하이", for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
        
        setTitleColor(.black, for: .normal)
        
    }
}
