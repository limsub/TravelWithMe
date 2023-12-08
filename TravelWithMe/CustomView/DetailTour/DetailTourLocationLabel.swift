//
//  DetailTourLocationLabel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/8/23.
//

import UIKit

class DetailTourLocationLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        font = .boldSystemFont(ofSize: 18)
        textColor = .black
        numberOfLines = 1
        textAlignment = .right
        
        text = "경복궁"
    }
    
    func updateLocation(_ name: String) {
        text = name
    }
    
}
