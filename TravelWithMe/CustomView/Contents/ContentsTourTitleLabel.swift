//
//  ContentsTourTitleLabel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit

class ContentsTourTitleLabel: UILabel {
    
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
        font = .boldSystemFont(ofSize: 20)
        text = "3박 4일 도쿄 여행 같이 가실분sadjfl;kjasd;lfkjas;dlfkja;slkdfja;sldkjf"
        numberOfLines = 2
    }
    
    
}
