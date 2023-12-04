//
//  ContentsTourProfileNameLabel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit


class ContentsTourProfileNameLabel: UILabel {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    convenience init(_ color: UIColor) {
        self.init()
        
        
        textColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        font = .boldSystemFont(ofSize: 16)
        textColor = .white
        text = "임승섭입니다"
    }
    
    
}
