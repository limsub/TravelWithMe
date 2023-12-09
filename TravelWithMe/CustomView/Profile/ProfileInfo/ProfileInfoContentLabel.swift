//
//  ProfileInfoContentLabel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit

class ProfileInfoContentLabel: UILabel {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    convenience init(_ content: String) {
        self.init()
        
        text = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp() {
        textColor = .black
        font = .systemFont(ofSize: 14)
        numberOfLines = 0
    }
}
