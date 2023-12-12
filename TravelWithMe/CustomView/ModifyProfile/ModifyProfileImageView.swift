//
//  ModifyProfileImageView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/11/23.
//

import UIKit

class ModifyProfileImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp() {
        clipsToBounds = true
        backgroundColor = UIColor.appColor(.disabledGray2)
        contentMode = .scaleAspectFill
        
        image = UIImage(named: "basicProfile2")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
    }
    

}
