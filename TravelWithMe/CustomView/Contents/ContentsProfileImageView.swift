//
//  ContentsProfileImageView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit
import SnapKit

class ContentsProfileImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    } 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        clipsToBounds = true
        
        image = UIImage(named: "sample")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
    }
}
